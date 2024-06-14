import os

def local_jupyter_notebook_bash():
    local_bash_file = '''
    #!/bin/bash
    {
        {
            echo; echo "...Starting Jupyter Notebooks Git Configuration..."
        }
    } && {
        {
            echo; echo "Creating filter..."
        } && {
            echo; git config filter.strip-notebook-output.clean 'jupyter nbconvert --ClearOutputPreprocessor.enabled=True --to=notebook --stdin --stdout --log-level=ERROR'
        } && {
            echo; echo "Filter Created."
        }
    } && {
        {
            echo "Adding .gitattributes..."    
        } && {
            echo "*.ipynb filter=strip-notebook-output"  >> .gitattributes
        } && {
            echo "Finished .gitattributes."
        }
    }
    '''

    with open("./config_j_notebooks.sh", 'w') as file:
        file.write(local_bash_file)

    os.system('sudo --validate --stdin && sudo chmod +x ./config_j_notebooks.sh && sudo bash ./config_j_notebooks.sh && bash ./config_j_notebooks.sh; sudo rm ./config_j_notebooks.sh')


