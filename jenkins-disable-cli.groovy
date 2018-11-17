#!groovy

// imports
import jenkins.model.Jenkins

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()

// disable Jenkins CLI
jenkins.getDescriptor("jenkins.CLI").get().setEnabled(false)

// save current Jenkins state to disk
jenkins.save()
