HOSTEDZONE=$(aws route53 list-hosted-zones --query 'HostedZones[?Name==`serverlessteam.com.`].Id' --output text)
USDOMAIN=$(aws cloudformation describe-stacks --stack-name serverless-keyvalue-dev --region us-west-2 --query 'Stacks[0].Outputs[?OutputKey==`DomainName`].OutputValue' --output text)
EUROPEDOMAIN=$(aws cloudformation describe-stacks --stack-name serverless-keyvalue-dev --region eu-central-1 --query 'Stacks[0].Outputs[?OutputKey==`DomainName`].OutputValue' --output text)

aws route53 change-resource-record-sets \
  --hosted-zone-id ${HOSTEDZONE} \
  --change-batch  '{
      "Comment": "optional comment about the changes in this change batch request",
      "Changes": [
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": "keyvalue.serverlessteam.com",
            "Type": "CNAME",
            "TTL": 300,
            "SetIdentifier": "us-west-2",
            "Region": "us-west-2",
            "ResourceRecords": [
              {
                "Value": "'${USDOMAIN}'"
              }
            ]
          }
        },
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": "keyvalue.serverlessteam.com",
            "Type": "CNAME",
            "TTL": 300,
            "SetIdentifier": "eu-central-1",
            "Region": "eu-central-1",
            "ResourceRecords": [
              {
                "Value": "'${EUROPEDOMAIN}'"
              }
            ]
          }
        }
      ]
    }'
