from setuptools import setup, find_packages

setup(
    name="todobackend",
    version="0.1.0",
    description="Todobackend Django REST service",
    packages=find_packages(),
    include_package_data=True,
    scripts=["manage.py"],
    # in the requirements.txt file with the . : pip install will look up the array in here
    install_requires=["django",
                      "djangorestframework",
                      "django-cors-headers",
                      "mysqlclient",
                      "uwsgi",
                      ],
    # in the requirements-test.txt file -e .[test]: pip will additionally install 'test' array
    # dependencies in the extra_require setting
    extras_require={
        "test": [
            "django-nose",
            "nose",
            "pinocchio",
            "coverage",
            "colorama",
        ]
    }
)
