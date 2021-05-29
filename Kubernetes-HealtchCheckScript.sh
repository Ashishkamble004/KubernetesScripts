#The Purpose of the Script is to Enable Quick Health Checks on the Clusters

#Date: 29th May 2021
#Author: Ashish Kamble

#!/bin/bash

echo "Please set up the Environment before running the script"
echo "-------------------------------------------------------"
echo "";
echo "Follow the Below Steps to proceed. If already done, press '"y"' to continue"
echo "---------------------------------------------------------------------------"

echo "1. To Logon to PKS API"
echo "-------"
echo "pks login -a <Kube API Server CNAME> -u <id> -k"
echo "Enter LDAP password"
echo ""
echo "2. To get clusters and logon to a specific cluster"
echo "-------"
echo "pks clusters"
echo "pks get-credentials <cluster-name>"

echo ""

read -p "Enter your answer: " answer

#Variable to check for proceeding or not
stans=y
ns=1

#Function for healthchecks UI
function healthchecks()
{
        clustername=`kubectl cluster-info | head -n1`
        echo ""
        echo "You are currently in Cluster $clustername";
        echo "--------"
        echo "Nodes Health Status"
        kubectl get nodes -o wide
        echo ""
        echo "Below are the Namespaces in the Cluster"
        echo ""
        echo "`kubectl get ns`";
        read -p "Please select any specific Namespace to proceed: " nss
        kubectl config set-context --current --namespace $nss
        echo "Current Namespace set is $nss"
        echo ""
        objectdetails
        selection

}
function namespace()
{
        echo "`kubectl get ns`";
        read -p "Please select any specific Namespace to proceed: " nss
        kubectl config set-context --current --namespace $nss
        echo "Current Namespace set is $nss"
        echo ""
        objectdetails
        selection

}
function objectdetails()
{
        #---------------
        echo "Objects in the current namespace"
        echo "--------------------------------"
        kubectl get all -o jsonpath={.items[*].kind} > garbage.txt
        tr -s [:space:] \\n < garbage.txt | sort | uniq
        rm -rf garbage.txt
        echo ""

}

function selection()
{
        #---------------
        read -p "Please enter the Resources you want to check: " object
        echo ""
        #Case for Object Selectio, calling function accordingly
        #----------
        case $object in
                Deployment)
                        Deployment
                        ;;
                Pod)
                        Pod
                        ;;
                Service)
                        Service
                        ;;
                ReplicaSet)
                        ReplicaSet
                        ;;
                HorizontalPodAutoscaler)
                                        HPA
                                        ;;
                Ingress)
                        Ingress
                        ;;
                PersistentVolume)
                                PV
                                ;;
                PersistentVolumeClaim)
                                PVC
                                ;;
                StorageClass)
                        StorageClass
                        ;;
                StatefulSet)
                        StatefulSets
                        ;;
                DaemonSet)
                        DaemonSet
                        ;;
        esac


}
#Function for Resources

function Pod()
{
        kubectl get pods -o wide

        echo ""
#       pod_var=`kubectl get pods -o jsonpath={..metadata.name}`
#       echo -e "PodName\t\t\t\t\t\t\t\tPodIP\t\t    RunningSince\t\tIsReady\t\tRestarts\t\tNodeName"
#       for i in $pod_var; do
#               Pod_Name=$(kubectl get pods $i -o jsonpath={.metadata.name})
#               Pod_IP=$(kubectl get pods $i -o jsonpath={..status.podIP})
#               Running_Since=$(kubectl get pods $i -o jsonpath={..status.startTime})
#               Is_Ready=$(kubectl get pods $i -o jsonpath={..status.conditions[1].status})
#               Restarts=$(kubectl get pods $i -o jsonpath={..status.containerStatuses[].restartCount})
#               Node_Name=$(kubectl get pods $i -o jsonpath={.spec.nodeName})
#               echo -e "$Pod_Name\t\t\t\t$Pod_IP\t$Running_Since\t\t$Is_Ready\t\t$Restarts\t\t$Node_Name"
#       done

        echo "Failed Pods: "
        kubectl get pods --field-selector status.phase=Failed
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read popt
         if [[ "$popt" == "$stans" ]]; then
           read -p "Enter Pod Name: " pname
           kubectl describe pods $pname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$popt" == "n" ]]; then
               option
        fi
}

function Deployment()
{
        kubectl get deployments -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read dopt
         if [[ "$dopt" == "$stans" ]]; then
           read -p "Enter Deployment Name: " dname
           kubectl describe deployment $dname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$dopt" == "n" ]]; then
               option
        fi

}
function Service()
{
        kubectl get svc -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read sopt
         if [[ "$sopt" == "$stans" ]]; then
           read -p "Enter Service Name: " sname
           kubectl describe service $sname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$sopt" == "n" ]]; then
               option
        fi
}
function HPA()
{
        kubectl get horizontalpodautoscaler -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read hpaopt
         if [[ "$hpaopt" == "$stans" ]]; then
           read -p "Enter HPA Name: " hpaname
           kubectl describe horizontalpodautoscaler $hpaname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$hpaopt" == "n" ]]; then
               option
        fi
}
function Ingress()
{
        kubectl get ingress -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read inopt
         if [[ "$inopt" == "$stans" ]]; then
           read -p "Enter Ingress Name: " ingname
           kubectl describe ingress $ingname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$popt" == "n" ]]; then
               option
        fi
}
function PV()
{
        kubectl get pv -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read pvopt
         if [[ "$pvopt" == "$stans" ]]; then
           read -p "Enter Persistent Volume Name: " pvname
           kubectl describe pv $pvname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$pvopt" == "n" ]]; then
               option
        fi

}
function PVC()
{
        kubectl get pvc -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read pvcopt
         if [[ "$pvcopt" == "$stans" ]]; then
           read -p "Enter Poersistenct Volume Claim Name: " pvcname
           kubectl describe persistentvolumeclaim $pvcname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$pvcopt" == "n" ]]; then
               option
        fi

}
function StorageClass()
{
        kubectl get storageclass -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read scopt
         if [[ "$scopt" == "$stans" ]]; then
           read -p "Enter Storage Class Name: " scname
           kubectl describe storageclass $scname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$scopt" == "n" ]]; then
               option
        fi

}
function StatefulSets()
{
        kubectl get statefulsets -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read sfopt
         if [[ "$sfopt" == "$stans" ]]; then
           read -p "Enter StatefulSet Name: " sfname
           kubectl describe statefulsets $sfname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$sfopt" == "n" ]]; then
               option
        fi

}
function DaemonSet()
{
        kubectl get Daemonsets -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read dsopt
         if [[ "$dsopt" == "$stans" ]]; then
           read -p "Enter DaemonSet Name: " dsname
           kubectl describe daemonset $dsname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$dsopt" == "n" ]]; then
               option
        fi

}
function ReplicaSet()
{
        kubectl get Replicaset -o wide
        echo ""
        echo "Do you want to Describe the above Object: press '"y"' to continue, '"n"' to Go back to Option Selection: "
        read rsopt
         if [[ "$rsopt" == "$stans" ]]; then
           read -p "Enter ReplicaSet Name: " rsname
           kubectl describe replicaset $rsname
           echo ""
           echo "Going back to option selections: "
           option
        elif [[ "$rsopt" == "n" ]]; then
               option
        fi

}
#---------------------------------


function option()
{
        echo "Do you want to go back to Object Selection? Press '"y"' to continue. Press '"1"' to Go back to Namespace Selection"
        read opt
        if [[ "$opt" == "$stans" ]]; then
           echo "Going back to Object Selection"
           objectdetails
           selection
        elif [[ "$opt" == "$ns" ]]; then
                namespace
        else
                echo "Bye!"
        fi

}

#------------------------------------

if [[ "$answer" == "$stans" ]]; then
    echo "Starting with Health Checks UI"
    healthchecks
else
    echo "Please setup the environment first. Bye!"
fi


