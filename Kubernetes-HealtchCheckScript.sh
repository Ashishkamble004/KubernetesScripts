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
echo "pks login -a op-pksapi.globetel.com -u <zamdid> -k"
echo "Enter GMail password"
echo ""
echo "2. To get clusters and logon to a specific cluster"
echo "-------"
echo "pks get-clusters"
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
        read -p "Please enter the Object you want to check: " object
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
                StatefulSets)
                        StatefulSets
                        ;;
                DaemonSet)
                        DaemonSet
                        ;;
        esac


}
#Function for Objects

function Pod()
{
        kubectl get pods
        echo "Summary: "

        option
}

function Deployment()
{
        kubectl get deployments
        option
}
function Service()
{
        kubectl get svc
        option
}
function HPA()
{
        kubectl get horizontalpodautoscaler
        option
}
function Ingress()
{
        kubectl get ingress
        option
}
function PV()
{
        kubectl get pv
        option
}
function PVC()
{
        kubectl get pvc
        option
}
function StorageClass()
{
        kubectl get storageclass
        option
}
function StatefulSets()
{
        kubectl get statefulsets
        option
}
function DaemonSet()
{
        kubectl get Daemonsets
        option
}
function ReplicaSet()
{
        kubectl get Replicaset
        option
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



