package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"

	httpHelper "github.com/gruntwork-io/terratest/modules/http-helper"
)

func testLambdaLB(t *testing.T, variant string) {
	t.Parallel()

	// Make sure we've set some required variables
	primaryHostedZone := assertTfVar(t, "primary_hosted_zone")
	assertTfVar(t, "owner")

	terraformDir := fmt.Sprintf("../examples/%s", variant)

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		LockTimeout:  "5m",
	}

	defer terraform.Destroy(t, terraformOptions)

	packageLambda(t, variant)

	expectedName := fmt.Sprintf("example-tf-lambda-lb-%s", variant)

	// This is annoying, but necessary. Log Group isn't cleaned up correctly after destroy.
	logGroupName := fmt.Sprintf("/aws/lambda/%s", expectedName)
	deleteLogGroup(t, logGroupName)

	terraform.InitAndApply(t, terraformOptions)

	awsAccountID := getAWSAccountID(t)
	awsRegion := getAWSRegion(t)

	expectedLambdaARN := fmt.Sprintf("arn:aws:lambda:%s:%s:function:%s", awsRegion, awsAccountID, expectedName)

	lambdaARN := terraform.Output(t, terraformOptions, "lambda_arn")
	assert.Equal(t, expectedLambdaARN, lambdaARN)

	expectedLambdaName := expectedName

	lambdaName := terraform.Output(t, terraformOptions, "lambda_name")
	assert.Equal(t, expectedLambdaName, lambdaName)

	expectedPartialLBARN := fmt.Sprintf("arn:aws:elasticloadbalancing:%s:%s:loadbalancer/app/%s", awsRegion, awsAccountID, expectedName)

	lbARN := terraform.Output(t, terraformOptions, "lb_arn")
	assert.Contains(t, lbARN, expectedPartialLBARN)

	lbSG := terraform.Output(t, terraformOptions, "lb_sg")
	assert.NotEmpty(t, lbSG)

	expectedDomainName := fmt.Sprintf("%s.%s", expectedName, primaryHostedZone)

	domainName := terraform.Output(t, terraformOptions, "domain_name")
	assert.Equal(t, expectedDomainName, domainName)

	baseURL := fmt.Sprintf("https://%s", domainName)
	expectedStatus := "OK"

	httpHelper.HttpGetWithRetry(t, baseURL, nil, 200, expectedStatus, 60, 5*time.Second)
}
