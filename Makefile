banner:
	@echo "#########################################################################"
	@echo "##                                                                     ##"
	@echo "##      ::: ::::::::::: :::    ::: :::::::::: ::::    :::     :::      ##" 
	@echo "##    :+: :+:   :+:     :+:    :+: :+:        :+:+:   :+:   :+: :+:    ##" 
	@echo "##   +:+   +:+  +:+     +:+    +:+ +:+        :+:+:+  +:+  +:+   +:+   ##" 
	@echo "##  +#++:++#++: +#+     +#++:++#++ +#++:++#   +#+ +:+ +#+ +#++:++#++:  ##" 
	@echo "##  +#+     +#+ +#+     +#+    +#+ +#+        +#+  +#+#+# +#+     +#+  ##" 
	@echo "##  #+#     #+# #+#     #+#    #+# #+#        #+#   #+#+# #+#     #+#  ##" 
	@echo "##  ###     ### ###     ###    ### ########## ###    #### ###     ###  ##" 
	@echo "##                                                                     ##"
	@echo "#########################################################################"
	@echo "                                                                          "                                                                                         "

vault:
	@echo "[vault] Getting configuration and secrets from Vault"
	@./bin/vault.sh

istio:
	@echo "[istio] Installing istio"
	@./bin/istio.sh

terraform: vault
	@echo "[terraform] Creating cluster system services with terraform"
	@./bin/terraform.sh

deploy: vault istio terraform

destroy: vault
	@echo "[bootstrap] Destroying cluster infrastructure"
	@cd terraform && terraform destroy -var-file="variables.tfvars"
