// Generated by CoffeeScript 1.4.0
(function() {
  var command, connection, create_album, create_soal, delete_album, delete_soal, http, mysql, reset_album, reset_soal;

  http = require('http');

  mysql = require('mysql');

  connection = mysql.createConnection({
    user: 'root',
    password: 'root',
    database: 'anbinh',
    port: '8889'
  });

  create_album = "CREATE TABLE IF NOT EXISTS ns_raw_albums (	id int not null,	album_id int,	album_name varchar(255),	thumbnail varchar(255),	artist varchar(150),	artist_id int)";

  create_soal = "CREATE TABLE IF NOT EXISTS ns_raw_songs_albums (	song_id int,	album_id int)";

  delete_album = "DROP TABLE ns_raw_albums";

  delete_soal = "DROP TABLE ns_raw_songs_albums";

  reset_album = "TRUNCATE TABLE ns_raw_albums";

  reset_soal = "TRUNCATE TABLE ns_raw_songs_albums";

  command = process.argv[2];

  if (command === "add") {
    connection.query(create_album);
    connection.query(create_soal);
    console.log("The table has been created!");
  }

  if (command === "delete") {
    connection.query(delete_album);
    connection.query(delete_soal);
    console.log("The table has been deleted");
  }

  if (command === "reset") {
    connection.query(reset_album);
    connection.query(reset_soal);
    console.log("The table has been reset");
  }

  connection.end();

}).call(this);
