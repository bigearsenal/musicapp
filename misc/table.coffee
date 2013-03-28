http = require 'http'
mysql = require 'mysql'
connection = mysql.createConnection {
	user : 'root'
	password: 'root'
	database: 'anbinh'
	port: '8889'
	} 

TABLE = {
	NSSongs : "nhacso"
	NSAlbums : "ns_raw_albums"
	NSSongs_Albums : "ns_raw_songs_albums"
	NSVideos : "ns_raw_videos"

	NVSongs : "Raw_NVSongs"
	NVAlbums : "Raw_NVAlbums"
	NVSongs_Albums : "Raw_NVSongs_Albums"
}


QUERY = {
	create : {
		NSSongs : " create table " + TABLE.NSSongs + " as select * from NSSongs where songid=1;" 
		NSAlbums : "CREATE TABLE IF NOT EXISTS " + TABLE.NSAlbums + " (
					id int not null,
					albumid int,
					album_name varchar(255),
					thumbnail varchar(255),
					artist varchar(150),
					artistid int
					)"
		NSVideos : 	"CREATE TABLE IF NOT EXISTS " + TABLE.NSVideos + " (
					videoid int not null,
					video_name varchar(255),
					link varchar(255),
					sublink varchar(255),
					thumbnail varchar(255),
					plays int,
					artist_list varchar(250)
					)"
		NSSongs_Albums : "CREATE TABLE IF NOT EXISTS " + TABLE.NSSongs_Albums + "(
						songid int,
						albumid int
						)"
		NVSongs :  "CREATE TABLE IF NOT EXISTS " + TABLE.NVSongs + " (
					songid int,
					song_name varchar(255),
					link varchar(255),
					link320 varchar(255)
					)"
	}
	remove : {
		NSSongs :  "DROP TABLE " + TABLE.NSSongs
		NSAlbums : "DROP TABLE " + TABLE.NSAlbums
		NSSongs_Albums : "DROP TABLE " + TABLE.NSSongs_Albums
		NSVideos : "DROP TABLE " + TABLE.NSVideos

		NVSongs :  "DROP TABLE " + TABLE.NVSongs
	}
	reset : {
		NSSongs : "TRUNCATE TABLE " + TABLE.NSSongs
		NSAlbums : "TRUNCATE TABLE " + TABLE.NSAlbums
		NSSongs_Albums : "TRUNCATE TABLE " + TABLE.NSSongs_Albums
		NSVideos : "TRUNCATE TABLE " + TABLE.NSVideos

		NVSongs : "TRUNCATE TABLE " + TABLE.NVSongs
	}
}


servertype = process.argv[2]
tabletype = process.argv[3]
command = process.argv[4]

switch servertype
	when "nhacso.net" then switch tabletype
		when "videos" then switch command 
			when "create" then (
				connection.query(QUERY.create.NSVideos)
				console.log "The tables: " + TABLE.NSVideos +  " have been created!"
			)
			when "remove" then (
				connection.query(QUERY.remove.NSVideos)
				console.log  "The tables: " + TABLE.NSVideos + " have been removed!"
			)
			when "reset" then (
				connection.query(QUERY.reset.NSVideos)
				console.log "The tables: "  + TABLE.NSVideos + " have been reset!"
			)
			else console.log "Wrong command!"		
		when "songs" then switch command 
			when "create" then console.log "songs created"
			when "remove" then console.log "table songs removed"
			when "reset" then (
				connection.query(QUERY.reset.NSSongs)
				console.log "The tables: "  + TABLE.NSSongs  + " have been reset!"
			)
			else console.log "Wrong command"
		when "albums" then switch command 
			when "create" then (
				connection.query(QUERY.create.NSAlbums)
				connection.query(QUERY.create.NSSongs_Albums)
				console.log "The tables: " + TABLE.NSAlbums + " and " + TABLE.NSSongs_Albums + " have been created!"
			)
			when "remove" then (
				connection.query(QUERY.remove.NSAlbums)
				connection.query(QUERY.remove.NSSongs_Albums)
				console.log  "The tables: " + TABLE.NSAlbums + " and " + TABLE.NSSongs_Albums + " have been removed!"
			)
			when "reset" then (
				connection.query(QUERY.reset.NSAlbums)
				connection.query(QUERY.reset.NSSongs_Albums)
				console.log "The tables: "  + TABLE.NSAlbums + " and " + TABLE.NSSongs_Albums + " have been reset!"
			)
			else console.log "Wrong command!"
		else console.log "Wrong table's type"
			
	when "nhac.vui.vn" then switch tabletype
		when "songs" then switch command 
			when "create" then (
				connection.query QUERY.create.NVSongs
				console.log "The table: " + TABLE.NVSongs + " has been created"
			) 
			when "remove" then (
				connection.query QUERY.remove.NVSongs
				console.log "The table: " + TABLE.NVSongs + " has been removed"
			)
			when "reset" then (
				connection.query QUERY.reset.NVSongs
				console.log "The table: " + TABLE.NVSongs + " has been reset"
			)
			else console.log "Wrong command"
		when "albums" then switch command 
			when "create" then (
				connection.query(QUERY.create.NVAlbums)
				connection.query(QUERY.create.NVSongs_Albums)
				console.log "The tables: " + TABLE.NVAlbums + " and " + TABLE.NVSongs_Albums + " have been created!"
			)
			when "remove" then (
				connection.query(QUERY.remove.NVAlbums)
				connection.query(QUERY.remove.NVSongs_Albums)
				console.log  "The tables: " + TABLE.NVAlbums + " and " + TABLE.NVSongs_Albums + " have been removed!"
			)
			when "reset" then (
				connection.query(QUERY.reset.NVAlbums)
				connection.query(QUERY.reset.NVSongs_Albums)
				console.log "The tables: "  + TABLE.NVAlbums + " and " + TABLE.NVSongs_Albums + " have been reset!"
			)
			else console.log "Wrong command!"
		else console.log "Wrong table's type"
	else console.log "Wrong Server's name"

connection.end()
