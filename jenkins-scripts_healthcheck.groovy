// delete builds for a job
//Jenkins.instance.getItemByFullName('JobName').builds.findAll { it.number > 10 && it.number < 1717 }.each { it.delete() }

// execute shell on master
def proc = 'df -h'.execute()
println proc.text

// get all jobs
Jenkins.instance.getAllItems(AbstractProject.class).collect { it.fullName }
