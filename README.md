#Lambda Layer
mkdir requests-layer && cd requests-layer
pip install requests -t python
zip -r ../requests-layer.zip python

#Lambda packaging
cd lambda
zip -r ../lambda_function.zip lambda_function.py