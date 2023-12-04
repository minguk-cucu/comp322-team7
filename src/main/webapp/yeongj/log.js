/**
 * 
 */

window.onload = function() {
	
	var detail_actions = document.getElementsByClassName("detail_action");
	for(i = 0 ; i<detail_actions.length;i++){
		var parent_id = detail_actions[i].parentElement.id;
		detail_actions[i].src = "./pics/"+detail_actions[i].id+"_"+parent_id+".png";
	}
	
	var event_img = document.getElementsByClassName("event_img");
	for(i = 0 ; i<event_img.length;i++){
		var parent_id = event_img[i].parentElement.id;
		if(event_img[i].id == "goal"){
			event_img[i].src = "./pics/"+event_img[i].id+"_"+parent_id+".png";
		}
		else{
			event_img[i].src = "./pics/"+event_img[i].id+".png";
		}
		
	}
	
}