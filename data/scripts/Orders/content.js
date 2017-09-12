// custom server side script used to fetch data from remote REST API
var http = require('http');

function getOrders(country, cb) {
    http.get({
        hostname: 'services.odata.org',
        port: 80,
        path: `/V4/Northwind/Northwind.svc/Orders?$filter=${encodeURI(`ShipCountry eq '${country}'`)}`,
    }, (result) => {
        var str = '';
        result.on('data', (b) => str += b);
        result.on('error', cb);
        result.on('end', () => cb(null, JSON.parse(str)));
    });
}

function beforeRender(req, res, done) {
    // the report parameter country can be send from the client API request
    req.data.country = req.data.country || 'France'
    getOrders(req.data.country, (err, json) => {        
        if (err) {
            return done(err);
        }
        
        var orders = json.value;
        var ordersByQuarter = {};
        
        orders.forEach((o) => {
            o.OrderDate = new Date(o.OrderDate);
            var key = o.OrderDate.getFullYear() + '/' + (o.OrderDate.getMonth() + 1);
            ordersByQuarter[key] = ordersByQuarter[key] || {
                value: 0,
                orderDate: o.OrderDate
            };
            ordersByQuarter[key].value++;
        });

        req.data.orders = orders;
        req.data.accumulatedOrders = ordersByQuarter;

        done();
    });
}