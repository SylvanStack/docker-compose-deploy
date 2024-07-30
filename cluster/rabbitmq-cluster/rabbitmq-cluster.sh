#!/bin/bash

#reset first node
echo "Reset first rabbitmq node."
#docker exec rabbitmq01 /bin/bash -c 'rabbitmqctl stop_app'
#docker exec rabbitmq01 /bin/bash -c 'rabbitmqctl reset'
#docker exec rabbitmq01 /bin/bash -c 'rabbitmqctl start_app'
#
##build cluster
#echo "Starting to build rabbitmq cluster with two ram nodes."
#docker exec rabbitmq02 /bin/bash -c 'rabbitmqctl stop_app'
#docker exec rabbitmq02 /bin/bash -c 'rabbitmqctl reset'
#docker exec rabbitmq02 /bin/bash -c 'rabbitmqctl join_cluster --ram rabbit@rabbitmq01'
#docker exec rabbitmq02 /bin/bash -c 'rabbitmqctl start_app'
#
#docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl stop_app'
#docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl reset'
#docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl join_cluster --ram rabbit@rabbitmq01'
#docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl start_app'
#
##check cluster status
#echo "Check cluster status:"
#docker exec rabbitmq01 /bin/bash -c 'rabbitmqctl cluster_status'
#docker exec rabbitmq02 /bin/bash -c 'rabbitmqctl cluster_status'
#docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl cluster_status'