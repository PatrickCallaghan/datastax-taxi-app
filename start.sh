echo 'Building schema'
mvn clean compile exec:java -Dexec.mainClass="com.datastax.demo.SchemaSetup" -DcontactPoints=localhost

echo 'Creating core'
dsetool create_core datastax_taxi_app.current_location reindex=true coreOptions=src/main/resources/solr/rt.yaml schema=src/main/resources/solr/geo.xml solrconfig=src/main/resources/solr/solrconfig.xml

echo 'Starting load data -> loader.log'
nohup mvn exec:java -Dexec.mainClass="com.datastax.taxi.Main" -DcontactPoints=localhost > loader.log &

echo 'Starting web server -> jetty.log'
nohup mvn jetty:run > jetty.log & 

sleep 5

open http://localhost:8080/datastax-taxi-app/rest/getmovements/2/20170406
