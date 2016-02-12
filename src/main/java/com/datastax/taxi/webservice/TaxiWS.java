package com.datastax.taxi.webservice;

import java.text.SimpleDateFormat;
import java.util.List;

import javax.jws.WebService;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.datastax.taxi.model.Vehicle;
import com.github.davidmoten.geo.LatLong;

@WebService
@Path("/")
public class TaxiWS {

	private Logger logger = LoggerFactory.getLogger(TaxiWS.class);
	private SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyyMMdd");

	//Service Layer.
	private TaxiService service = new TaxiService();
	
	@GET
	@Path("/getmovements/{vehicle}/{date}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getMovements(@PathParam("vehicle") String vehicle, @PathParam("date") String dateString) {
				
		List<Vehicle> result = service.getVehicleMovements(vehicle, dateString);
		
		return Response.status(201).entity(result).build();
	}
	
	@GET
	@Path("/getvehicles/{tile}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getVehiclesByTile(@PathParam("tile") String tile) {
				
		List<Vehicle> result = service.getVehiclesByTile(tile);
		
		return Response.status(201).entity(result).build();
	}

	@GET
	@Path("/search/{lat}/{lon}/{distance}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response searchForVehicles(@PathParam("lat") double lat, @PathParam("lon") double lon, @PathParam("distance") int distance) {
				
		List<Vehicle> result = service.searchVehiclesByLonLatAndDistance(distance, new LatLong(lat,lon));
		
		return Response.status(201).entity(result).build();
	}	
}
