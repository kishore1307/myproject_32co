#!/bin/bash

aws secretsmanager create-secret \
  --name DB_PASSWORD \
  --secret-string "Roger@365"
