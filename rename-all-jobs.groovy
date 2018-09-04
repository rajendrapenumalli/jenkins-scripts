import hudson.model.*
import jenkins.model.Jenkins
 
Jenkins jenkins = Jenkins.getInstance()
 
def sourceViewName  = "source-view" 
def sourceView = Hudson.instance.getView(sourceViewName)

for(item in sourceView.getItems())
{
 try {
      //create the new project name
      targetJobName = item.getName() + "-cur"
     
      item.renameTo(targetJobName)
     
      println(" $item.name -> $targetJobName")
   }
    catch(Exception e) {
        println "Can't create job $targetJobName : ${e.message}"
    }

}

jenkins.save()
