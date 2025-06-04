#!/bin/bash
set -e

NAME="${1}"
REGION="${2}"

RESOURCE_CONFIGURATION_ID=$(aws vpc-lattice list-resource-configurations \
  --query "items[?name=='${NAME}'].id | [0]" \
  --output text \
  --region ${REGION})

DOMAIN_NAME=$(aws vpc-lattice list-service-network-resource-associations \
  --query "items[?resourceConfigurationId=='${RESOURCE_CONFIGURATION_ID}'].dnsEntry.domainName | [0]" \
  --output text \
  --region ${REGION})

echo "{\"resource_configuration_id\": \"$RESOURCE_CONFIGURATION_ID\", \"domain_name\": \"$DOMAIN_NAME\"}"