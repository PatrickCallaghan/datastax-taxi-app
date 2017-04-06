echo 'Installing Maven'
if [ -f /etc/redhat-release ]; then
  yum install maven
fi

if [ -f /etc/lsb-release ]; then
  apt-get install maven
fi

echo 'Building schema'
mvn clean compile exec:java -Dexec.mainClass="com.datastax.demo.SchemaSetup" -DcontactPoints=localhost

echo 'Creating core'
dsetool create_core datastax_taxi_app.current_location reindex=true schema=src/main/resources/solr/geo.xml solrconfig=src/main/resources/solr/solrconfig.xml

echo 'Starting load data -> loader.log'
nohup mvn exec:java -Dexec.mainClass="com.datastax.taxi.Main" -DcontactPoints=node0 > loader.log &

echo 'Starting web server on port 8081 -> jetty.log'
nohup mvn jetty:run -DcontactPoints=node0 -Djetty.port=8081 > jetty.log & 

sleep 2

echo 'Finished setting up'
