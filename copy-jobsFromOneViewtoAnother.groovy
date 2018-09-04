import hudson.model.*
import jenkins.model.Jenkins
 
Jenkins jenkins = Jenkins.getInstance()
 
def sourceViewName  = "source-view"
def targetViewName  = "target-view"
def search = "-dev"
def replace = "-sta"
 
def sourceView = Hudson.instance.getView(sourceViewName)

jenkins.addView(new ListView(targetViewName))
def targetView = Hudson.instance.getView(targetViewName)
 
for(item in sourceView.getItems())
{
	try {
		targetJobName = item.getName().replace(search , replace)
     
		def job = Hudson.instance.copy(item, targetJobName)
		job.save()
      
		targetView.doAddJobToView(targetJobName)     
		
		println("$item.name -> $targetJobName")
    }
    catch(Exception e) {
        println "Can't create job $targetJobName : ${e.message}"
    }

}

jenkins.save()
