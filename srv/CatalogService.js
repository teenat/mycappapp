module.exports = cds.service.impl( async function(){

    //it will look our CatalogService.cds file and get 
    //the object of the corresponding entity so that we can
    //tell capm which entity i want to add generic handler
    const { EmployeeSet, POs } = this.entities;

    this.before(['UPDATE','CREATE'], EmployeeSet, (req, res) => {
        console.log("aa gaya " + JSON.stringify(req.data));
        var jsonData = req.data;
        if(jsonData.hasOwnProperty("salaryAmount")){
            const salary = parseFloat(req.data.salaryAmount);
            if(salary > 1000000){
                req.error(500, "Bro, The salary cannot be above 1 Million 😊");
            }
        }

    });

    this.after('READ',EmployeeSet,(req,res) => {
        console.log(JSON.stringify(res))
        //exercise: avoid loop and perform same using map function
        var finalData = [];
        for (let i = 0; i < res.results.length; i++) {
            const element = res.results[i];
            element.salaryAmount = element.salaryAmount * 1.10;
            finalData.push(element)
        }
        finalData.push({
            "ID": "dummuy",
            "nameFirst": "Michel",
            "nameLast": "Saylor"
        })
        res.results = finalData;
    });


    ///implementation for the function
    this.on('getMostExpensiveOrder', async (req,res) => {
        try {
            const tx = cds.tx(req);

            const myData = await tx.read(POs).orderBy({
                "GROSS_AMOUNT": 'desc'
            }).limit(1);

            return myData;
        } catch (error) {
            return "Hey Amigo !" + error.toString();
        }
    });

    ///implementation for the function
    this.on('getOrderDefault', async (req,res) => {
        try {
            return { OVERALL_STATUS : 'N'}
        } catch (error) {
            return "Hey Amigo !" + error.toString();
        }
    });

    ///instance bound action
    this.on('boost', async(req, res)=>{
        try {
            //programmatically check @ runtime, if the user have the Editor permission
            req.user.is('Editor') || req.reject(403)
            const POID = req.params[0];
            console.log("Bro your PO id was " + JSON.stringify(POID));
            const tx = cds.tx(req);
            await tx.update(POs).with({
                "GROSS_AMOUNT" : { '+=' : 20000 }
            }).where({ID: POID});
            //after modify, read the instance
            const reply = tx.read(POs).where({ID: POID});
            return reply;
        } catch (error) {
            return "Hey Amigo !" + error.toString();
        }
    });

    this.on('setDelivered', async(req, res)=>{
        try {
            //programmatically check @ runtime, if the user have the Editor permission
            const POID = req.params[0];
            console.log("Bro your PO id was " + JSON.stringify(POID));
            const tx = cds.tx(req);
            await tx.update(POs).with({
                "OVERALL_STATUS" : 'D'
            }).where({ID: POID});
            //after modify, read the instance
            const reply = tx.read(POs).where({ID: POID});
            return reply;
        } catch (error) {
            return "Hey Amigo !" + error.toString();
        }
    });

});


