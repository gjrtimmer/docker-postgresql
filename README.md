# PostgreSQL

## Error Exit Codes

| Code | Description                                                                     | Resolution                                                       |
| ---- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| 101  | Invalid permissions for `PG_CERTS_DIR/server.crt`                               | File permissions for server.crt needs to be set to `644`         |
| 102  | Invalid permissions for `PG_CERTS_DIR/server.key`                               | File permissions for server.key needs to be set to `640`         |
| 201  | Required variable `DB_USER` not set                                             | Add environment variable DB_USER to container                    |
| 202  | Required variable `DB_PASS` not set                                             | Add environment variable DB_PASS to container                    |
| 203  | Required variable `DB_NAME` not set                                             | Add environment variable DB_NAME to container                    |
| 204  | Required variable `REPLICATION_HOST` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_HOST` to container         |
| 205  | Required variable `REPLICATION_USER` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_USER` to container         |
| 206  | Required variable `REPLICATION_PASS` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_PASS` to container         |
| 220  | Timeout while connecting to REPLICATION_HOST                                    | Ensure network connection to Replication Host van be established |
| 230  | Failed to install old PostgreSQL version for data migration                     | TODO                                                             |