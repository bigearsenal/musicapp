CREATE OR REPLACE FUNCTION plv8_add_coverart_amalbums() RETURNS
varchar AS $$

var plan = plv8.prepare( 'SELECT * FROM amalbums' );
var cursor = plan.cursor();
var row;
while (row = cursor.fetch()) {
  for (var i=0;i < row.discographies.length;i++){
	plv8.execute("UPDATE amalbums SET coverart='" + row.discographies[i].coverart.replace("JPG_75","JPG_400") + "' WHERE id=" + row.discographies[i].id + " ;");
  }
}

cursor.close();
plan.free();
return "DONE";
$$ LANGUAGE plv8 IMMUTABLE STRICT;