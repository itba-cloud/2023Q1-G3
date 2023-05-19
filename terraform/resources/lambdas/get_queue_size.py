def main(event, context):
    test = {
        "kansas": 5,
        "mc_donalls": 6,
        "burger_king": 2,
    }
    return {
       "queue_size": test[event["queryStringParameters"]['restaurant']]
   }
