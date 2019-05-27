# URL Shortener IaC

This is the Infrastructure as Code for the URL Shortener project. It uses the [Troposphere](https://github.com/cloudtools/troposphere) Python library for generating CloudFormation templates.

## Set up

It is recommended to use a virtual environment. A useful tutorial is found [here](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/). You will also need the Troposphere library installed.

```
# Create virtual environment
python3 -m venv env

# Use virtual environment
source env/bin/activate

# Install dependencies
pip install -r requirements.txt
```
