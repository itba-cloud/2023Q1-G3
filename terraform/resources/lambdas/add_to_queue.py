def main(event, context):
    message = 'your email {} and {} was registered!'.format(event['email'], event['phoneNumber'])
    return {
       "message": message
   }
