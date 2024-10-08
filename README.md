
### Clone o repositório:
```
$ git clone https://github.com/Mr-Zer00/Universal-Linux-Package-Installer.git
$ cd Universal-Linux-Package-Installer
```

### Torne o script executável:
```
$ chmod +x multi-install-packages.sh
```

### Execute o script:
```
$ ./install_packages_deps.sh
```

---

### Funcionalidades do Script

* **Identifica a distribuição Linux:** Detecta automaticamente qual distribuição Linux você está usando e aplica o gerenciador de pacotes adequado.
   
* **Exibe pacotes e dependências:** Para cada pacote, lista as dependências (se houver) e exibe-as na saída.
   
* **Lista de pacotes personalizável:** Você pode modificar a variável PACKAGES no script para instalar os pacotes de sua escolha.

* **Instalação opcional de dependências:** O script dá a opção de instalar as dependências ou apenas os pacotes principais.

### Personalização

Para personalizar o script, basta modificar a variável `PACKAGES` no script. Por exemplo, se você quiser instalar `wget`, `curl` e `git`, pode alterar a linha:
```
PACKAGES=("packages")
```
