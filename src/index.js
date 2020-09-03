
const LAMBDA_NAME = process.env.LAMBDA_NAME

exports.handler = async function (event, context, callback) {
    console.log("You have reached the handler")
    return await performOperation(callback, event.body)
}

performOperation = async = (callback, body) => {
    try {
        console.log(body)
        return callback(null , { statusCode: 200, body: {message: `Successful execution for ${LAMBDA_NAME}`}, headers: {'x-custom-header': 'my custom header value'} })
        
    } catch (err) {
        console.log(err, err.stack)
    }
}