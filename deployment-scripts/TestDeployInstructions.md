create github personal access token from settings>developer>personal access token. It just needs public_repo access
create npm personal access token from profile icon>access tokens
Make sure to verify email address in npm otherwise there will be an error 403 on publish

brew install travis
travis login --pro
travis encrypt MY_ENV_VAR=mysecretvalue --add env.global --pro # put a space at the front so it's not saved in shell autocomplete

set up local emulated s3 bucket to test:
docker run -d -p 9444:9000 scireum/s3-ninja:6
Go to localhost:9444/ui
Create a bucket called oclif-test
Click make public
Copy access key and secret key
use travis encrypt to add them as AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
Go to package.json and set oclif.update.s3.bucket to 'oclif-test'

./ngrok http 9444
Copy the link location
Go to .travis.yml and add to env.global: AWS_REGION = http://something.ngrok.io/s3, AWS_S3_ENDPOINT = http://something.ngrok.io/s3/

For testing, just put in env.global: UPDATE_TYPE = "patch"
