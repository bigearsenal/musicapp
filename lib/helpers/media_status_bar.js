
var charm = require('charm');
function StatusBar(options) {
  options = options || {};

  // Total number of items to process.
  if (!options.total) {
    throw new Error('You MUST specify the total number of operations that will be processed.');
  }
  this.total = options.total;

  // Current item number.
  this.current = 0;

  // Maximum percent of total time the progressbar is allowed to take during processing.
  // Defaults to 0.5%
  this.max_burden = options.maxBurden || 0.5;

  // Whether to show current burden %.
  this.show_burden = options.showBurden || false;


  // Internal time tracking properties.
  this.started = false;
  this.size = 80;
  this.inner_time = 0;
  this.outer_time = 0;
  this.elapsed = 0;
  this.time_start = 0;
  this.time_end = 0;
  this.time_left = 0;
  this.time_burden = 0;
  this.skip_steps = 0;
  this.skipped = 0;
  this.aborted = false;

  // Setup charm.
  this.charm = charm();
  this.charm.pipe(process.stdout);

  // Prepare the output.
  this.charm.write("\n\n\n");
}
module.exports = function(options) {
  if (typeof options === 'number') {
    options = {
      total: options
    };
  }
  return new StatusBar(options);
};
StatusBar.prototype.show = function op(count,status) {
  if (count) {
    this.current = count;
  }
  else {
    this.current++;
  }

  if (status){
    this.status = status;
  }
  else {
    this.status = null;
  }


  if (this.burdenReached()) {
    return;
  }

  // Record the start time of the whole task.
  if (!this.started) {
    this.started = new Date().getTime();
  }

  // Record start time.
  this.time_start = new Date().getTime();

  this.updateTimes();
  this.clear();
  this.outputProgress(this.status);
  this.outputStats();
  this.outputTimes();

  // The task is complete.
  if (this.current >= this.total) {
    this.finished();
  }

  // Record end time.
  this.time_end = new Date().getTime();
  this.inner_time = this.time_end - this.time_start;
};

StatusBar.prototype.setTotal = function setTotal(total){
  this.total = total;
};
StatusBar.prototype.updateTimes = function updateTimes() {
  this.elapsed = this.time_start - this.started;
  if (this.time_end > 0) {
    this.outer_time = this.time_start - this.time_end;
  }
  if (this.inner_time > 0 && this.outer_time > 0) {
    // Set Current Burden
    this.time_burden = (this.inner_time / (this.inner_time + this.outer_time)) * 100;

    // Estimate time left.
    this.time_left = (this.elapsed / this.current) * (this.total - this.current);

    if (this.time_left < 0) this.time_left = 0;
  }
  // If our "burden" is too high, increase the skip steps.
  if (this.time_burden > this.max_burden && (this.skip_steps < (this.total / this.size))) {
    this.skip_steps = Math.floor(++this.skip_steps * 1.3);
  }
};


StatusBar.prototype.clear = function clear() {
  this.charm.erase('line').up(1).erase('line').up(1).erase('line').write("\r");
};

StatusBar.prototype.outputProgress = function outputProgress(status) {
  // this.charm.write('');

  var text;
  text = "▶ ";
  if (this.current === this.total) {
    text = "■  ";
  }
  if (status === "pause"){
    text = "■  ";
  }
 
  var percent = (this.current/this.total)*100;
  percent = percent.toFixed(2);
  text += percent + "%   " + formatNumber(this.current) + "/" + formatNumber(this.total);
  var len = text.length;
  left = (this.size-len)/2|0;
  right = ((this.size-len)/2|0) + (this.size-len)%2;
  // console.log(left);
  // console.log(right);
  // console.log(len);
  var bar = Array(left+1).join(' ') + text + Array(right+1).join(' ');

  // console.log(bar.length);
  this.charm.foreground('black').background('green');
  for (var i = 0; i < ((this.current / this.total) * this.size) - 1 ; i++) {
     this.charm.write(bar[i]);
  }
  this.charm.foreground('black').background('white');
  while (i < this.size - 1) {
    this.charm.write(bar[i]);
    i++;
  }
  if (this.time_left){
    this.charm.display('reset').down(1).left(100);
  }
  else {
    this.charm.display('reset');
  }

};

StatusBar.prototype.outputStats = function outputStats() {

  if (this.show_burden) {
    this.charm.write('    ').display('bright').write('Burden: ').display('reset');
    this.charm.write(this.time_burden.toFixed(2) + '% / ' + this.skip_steps);
  }
  if (this.time_left){
    if (this.extraInfo){
      this.charm.write('').display('bright').write('Extra: ').display('reset');
      this.charm.write(this.extraInfo);
    }
    this.charm.display('reset').down(1).left(100);
  }  
};

StatusBar.prototype.outputTimes = function outputTimes() {

  var hours = Math.floor(this.elapsed / (1000 * 60 * 60));
  var min = Math.floor(((this.elapsed / 1000) % (60 * 60)) / 60);
  var sec = Math.floor((this.elapsed / 1000) % 60);
  if (this.time_left) {
    this.charm.write('').display('bright').write('Elapsed: ').display('reset');
    this.charm.write(hours + 'h ' + min + 'm ' + sec + 's');
  }
  if (this.time_left){
    hours = Math.floor(this.time_left / (1000 * 60 * 60));
    min = Math.floor(((this.time_left / 1000) % (60 * 60)) / 60);
    sec = Math.ceil((this.time_left / 1000) % 60);

    this.charm.write('   ').display('bright').write('Remaining: ').display('reset');
    this.charm.write(hours + 'h ' + min + 'm ' + sec + 's');
  }
};

StatusBar.prototype.finished = function finished() {
};

StatusBar.prototype.burdenReached = function burdenReached() {
  // Skip this cycle if the burden has determined we should.
  if ((this.skip_steps > 0) && (this.current < this.total)) {
    if (this.skipped < this.skip_steps) {
      this.skipped++;
      return true;
    }
    else {
      this.skipped = 0;
    }
  }
  return false;
};

function padLeft(str, length, pad) {
  pad = pad || ' ';
  while (str.length < length)
    str = pad + str;
  return str;
}

function formatNumber(number, decimals, dec_point, thousands_sep) {
  number = (number + '').replace(/[^0-9+\-Ee.]/g, '');
  var n = !isFinite(+number) ? 0 : +number,
    prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
    sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
    dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
    s = '',
    toFixedFix = function (n, prec) {
      var k = Math.pow(10, prec);
      return '' + Math.round(n * k) / k;
    };
  // Fix for IE parseFloat(0.55).toFixed(0) = 0;
  s = (prec ? toFixedFix(n, prec) : '' + Math.round(n)).split('.');
  if (s[0].length > 3) {
    s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
  }
  if ((s[1] || '').length < prec) {
    s[1] = s[1] || '';
    s[1] += new Array(prec - s[1].length + 1).join('0');
  }
  return s.join(dec);
}
