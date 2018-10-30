#!/bin/bash

tar cvzf multipass.box ./metadata.json
vagrant box add multipass.box --name multipass