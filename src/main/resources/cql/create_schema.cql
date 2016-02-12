create keyspace if not exists datastax_taxi_app WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1' };

use datastax_taxi_app; 
 
create table if not exists current_location(
	vehicle text PRIMARY KEY,
	tile1 text,
	tile2 text,	
	lat_long text,
	date timestamp
) WITH compaction = { 'class' :  'LeveledCompactionStrategy'  };

create table if not exists vehicle(
	vehicle text,
	day text,
	date timestamp, 
	lat_long text,
	tile2 text,
	PRIMARY KEY ((vehicle,day), date)
) with clustering order by (date desc);


truncate current_location;
truncate vehicle;


