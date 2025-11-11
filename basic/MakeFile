# Makefile for curl test pod

# Variables
CURL_POD := curl
TARGET_POD := ngijen
PORT ?= 80   # Default port if not passed (can be overridden: make test PORT=8080)

# Create curl pod
apply:
	kubectl apply -f curl-pod.yaml
	kubectl wait --for=condition=Ready pod/$(CURL_POD) --timeout=60s

# Get and store Pod IP of target pod
getip:
	@kubectl get pod $(TARGET_POD) -o jsonpath='{.status.podIP}' | tee pod_ip.txt
	@echo "\nSaved Pod IP to pod_ip.txt"

# Test connectivity to given port (depends on getip)
test: getip
	$(eval POD_IP := $(shell cat pod_ip.txt))
	@echo "Testing http://$(POD_IP):$(PORT) ..."
	@kubectl exec -it $(CURL_POD) -- wget -qO- http://$(POD_IP):$(PORT) || echo "Connection failed"

# Cleanup curl pod
clean:
	kubectl delete pod $(CURL_POD) --ignore-not-found
	rm -f pod_ip.txt
