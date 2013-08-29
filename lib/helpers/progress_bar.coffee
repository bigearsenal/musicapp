class ProgressBar
	constructor : (options)->
		options = options or {}
		@current = 0
		@current = 0
		@max_burden = options.maxBurden or 0.1
		@show_burden = options.showBurden or false
		@total = options.total or 10
		@started = false
		@size = 80
		@inner_time = 0
		@outer_time = 0
		@elapsed = 0
		@time_start = 0
		@time_end = 0
		@time_left = 0
		@time_burden = 0
		@skip_steps = 0
		@skipped = 0
		@aborted = false
		@firstTime = true
		@charm = require('../../node_modules/charm')()
		@charm.pipe process.stdout
	show : (count, extraInfo) ->
		if count
		  @current = count
		else
		  @current++
		if extraInfo
		  @extraInfo = extraInfo
		else
		  @extraInfo = null
		return  if @burdenReached()
		
		# Record the start time of the whole task.
		@started = new Date().getTime()  unless @started
		
		# Record start time.
		@time_start = new Date().getTime()

		@updateTimes()

		if @firstTime is false
			@clear()
		else
			@firstTime = false

		@outputProgress()
		
		# The task is complete.
		if @current >= @total
			@charm.erase("line").up(1).erase("line").up(1).erase("line").up(1).left(100) 
		
		# Record end time.
		@time_end = new Date().getTime()
		@inner_time = @time_end - @time_start

	setTotal : (total) ->
		@total = total

	updateTimes : ->
		@elapsed = @time_start - @started
		@outer_time = @time_start - @time_end  if @time_end > 0
		if @inner_time > 0 and @outer_time > 0
			
			# Set Current Burden
			@time_burden = (@inner_time / (@inner_time + @outer_time)) * 100
			
			# Estimate time left.
			@time_left = (@elapsed / @current) * (@total - @current)
			@time_left = 0  if @time_left < 0
		
		# If our "burden" is too high, increase the skip steps.
		@skip_steps = Math.floor(++@skip_steps * 1.3)  if @time_burden > @max_burden and (@skip_steps < (@total / @size))

	clear : ->
		@charm.erase("line").up(1).erase("line").up(1).erase("line").up(1).erase("line").left(100)


	outputProgress : ->
		text = "Running....   "
		text = "Completed!   "  if @current is @total
		percent = (@current / @total) * 100
		percent = percent.toFixed(2)
		text += percent + "%   " + @formatNumber(@current) + "/" + @formatNumber(@total)
		len = text.length
		left = (@size - len) / 2 | 0
		right = ((@size - len) / 2 | 0) + (@size - len) % 2
		bar = Array(left + 1).join(" ") + text + Array(right + 1).join(" ")
		
		@charm.foreground("black").background("green")
		i = 0

		while i < ((@current / @total) * @size) - 1
			@charm.write bar[i]
			i++
		@charm.foreground("black").background "white"
		while i < @size - 1
			@charm.write bar[i]
			i++

		@charm.display('reset')
		console.log ""
		console.log "Extra: #{@extraInfo}"

		# output time
		hours = Math.floor(@elapsed / (1000 * 60 * 60))
		min = Math.floor(((@elapsed / 1000) % (60 * 60)) / 60)
		sec = Math.floor((@elapsed / 1000) % 60)
		timeMessage = ""
		timeMessage += "Elapsed: "
		timeMessage += hours + "h " + min + "m " + sec + "s"
		hours = Math.floor(@time_left / (1000 * 60 * 60))
		min = Math.floor(((@time_left / 1000) % (60 * 60)) / 60)
		sec = Math.ceil((@time_left / 1000) % 60)
		timeMessage += "   Remaining: "
		timeMessage += hours + "h " + min + "m " + sec + "s"
		console.log timeMessage


	formatNumber : (number, decimals, dec_point, thousands_sep) ->
		number = (number + "").replace(/[^0-9+\-Ee.]/g, "")
		n = (if not isFinite(+number) then 0 else +number)
		prec = (if not isFinite(+decimals) then 0 else Math.abs(decimals))
		sep = (if (typeof thousands_sep is "undefined") then "," else thousands_sep)
		dec = (if (typeof dec_point is "undefined") then "." else dec_point)
		s = ""
		toFixedFix = (n, prec) ->
			k = Math.pow(10, prec)
			"" + Math.round(n * k) / k

		
		# Fix for IE parseFloat(0.55).toFixed(0) = 0;
		s = ((if prec then toFixedFix(n, prec) else "" + Math.round(n))).split(".")
		s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep)  if s[0].length > 3
		if (s[1] or "").length < prec
			s[1] = s[1] or ""
			s[1] += new Array(prec - s[1].length + 1).join("0")
		s.join dec
	reset : ->
		@current = 0
		@max_burden = 0.1
		@show_burden = false
		@started = false
		@inner_time = 0
		@outer_time = 0
		@elapsed = 0
		@time_start = 0
		@time_end = 0
		@time_left = 0
		@time_burden = 0
		@skip_steps = 0
		@skipped = 0
		@aborted = false
		@firstTime = true

	burdenReached : ->
		if (@skip_steps > 0) and (@current < @total)
		  if @skipped < @skip_steps
		    @skipped++
		    return true
		  else
		    @skipped = 0
		false

module.exports = ProgressBar