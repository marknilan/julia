 function getDlexuToml() {
    
        document.getElementById('fileInput').addEventListener('change', function(event) {
            const file = event.target.files[0];
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('output').textContent = e.target.result;
            };
            reader.readAsText(file);
        });
 }


window.onbeforeunload = function() {
            return "Are you sure you want to leave DLEXU?";
              };

              function closePage() {
            window.close();
}
