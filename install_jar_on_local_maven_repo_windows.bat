SET groupId=test
SET artifactId=test
SET version=0.0.1
mvn install:install-file -Dfile=%artifactId%-%version%.jar -DgroupId=%groupId% -DartifactId=%artifactId% -Dversion=%version% -Dpackaging=jar -DgeneratePom=true