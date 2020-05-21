FUNCTION_MODULE='loaded'

function deleteFile {
   file=$1

   if [[ "$debugMode" != "true" ]]
   then 
    echo "deleting file: " $file
    rm -f $file
   fi
}