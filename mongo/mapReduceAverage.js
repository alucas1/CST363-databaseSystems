//Name:Alberto Lucas
//Date:02/16/2021
//Class:CST363
//Desc: code a script4.js file that does a map reduce that answers this question: 
// What is the average quantity for orders? Requires orders_load.js to be loaded.

// Map phase - each value is emitted as a qty with a constant key
mapf = function () {
	total = 0;
	for(x of this.items) {
		total = total + x.qty;
	}
	emit(0, {qty:total});
}

// Reduce phase - each value is counted as an order, and the qty's are added together. 
reducef = function(key, values) {
	count = 0;
	totalqty = 0;
	for(x of values) {
		totalqty += x.qty;
		count++;
	}
	return {average_qty_of_all_orders:totalqty/count};
}

db.orders.mapReduce(mapf, reducef, {out: "out_collection"});
 
// Print output
cursor = db.out_collection.find();
while(cursor.hasNext()) {
	printjson(cursor.next());
}