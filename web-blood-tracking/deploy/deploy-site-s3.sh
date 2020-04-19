#aws s3 mb s3://h3.abcgov.com.br --region us-east-1
aws s3 sync ../web s3://h3.abcgov.com.br --region us-east-1 --delete

