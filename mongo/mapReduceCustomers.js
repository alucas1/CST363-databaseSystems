//Name:Alberto Lucas
//Date:02/16/2021
//Class:CST363
//Desc: code a script2.js file that does a map reduce of the customers collections 
// and produces a report that shows zip code that start with ‘9’ and the count of 
// customers for each zip code. Requires customers_load.js to be loaded.

// Map phase - Assign a value of 1 to zip codes that start with 9
mapf = function () {
	if(this.address.zip[0] === "9") {
		emit(this.address.zip, 1);	
	}
}

// Reduce phase - Add all values 
reducef = function(key, values) {
	total = 0;
	for(x of values) {
		total = total + x;
	}
	return {zipcode:key, customer_count:total};
}

db.customers.mapReduce(mapf, reducef, {out: "out_collection"});

// Print output
print("**************************")
print("Customers that live in a zip code starting with 9:");
cursor = db.out_collection.find();
while(cursor.hasNext()) {
	printjson(cursor.next());
}