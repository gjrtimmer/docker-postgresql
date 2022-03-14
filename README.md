# PostgreSQL

## Error Exit Codes

| Code | Description                                                                     | Resolution                                                       |
| ---- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| 10   | Failed to install old PostgreSQL version for data migration                     | TODO                                                             |
| 15   | Required variable `DB_USER` not set                                             | Add environment variable DB_USER to container                    |
| 16   | Required variable `DB_PASS` not set                                             | Add environment variable DB_PASS to container                    |
| 17   | Required variable `DB_NAME` not set                                             | Add environment variable DB_NAME to container                    |
| 18   | Required variable `REPLICATION_HOST` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_HOST` to container         |
| 19   | Required variable `REPLICATION_USER` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_USER` to container         |
| 20   | Required variable `REPLICATION_PASS` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_PASS` to container         |
| 30   | Timeout while connecting to REPLICATION_HOST                                    | Ensure network connection to Replication Host van be established |
| 41   | Certificate not found `PG_CERTS_DIR/server.crt`                                 | Place certificate in correct path                                |
| 42   | Invalid permissions for `PG_CERTS_DIR/server.crt`                               | File permissions for server.crt needs to be set to `644`         |
| 43   | Certificate not found `PG_CERTS_DIR/server.key`                                 | Place certificate in correct path                                |
| 44   | Invalid permissions for `PG_CERTS_DIR/server.key`                               | File permissions for server.key needs to be set to `640`         |
| 50   | Backup completed succesfully                                                    | N.A.                                                             |
| 51   | Backup failed                                                                   | Check log file                                                   |
| 52   | Invalid option for PG_BACKUP_FORMAT                                             | Valid options: `p|plain` or `t|tar`                              |
| 61   | Snapshot failed                                                                 | Check logfile                                                    |
