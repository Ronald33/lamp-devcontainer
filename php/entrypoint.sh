#!/bin/bash

configure-permissions "$MY_WORKDIR" "$MY_USER_NAME" "$MY_GROUP_NAME"
exec apache2-foreground

su - $MY_USER_NAME
