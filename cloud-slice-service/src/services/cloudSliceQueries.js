module.exports = {
    GET_ALL_AWS_SERVICES:`SELECT * FROM awsservices`,
    INSERT_LAB_DATA:`INSERT INTO cloudslicelab(createdby,services, region, startDate, endDate, cleanupPolicy, platform, provider, title, description, modules) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING *`,
}