package com.demo.services;

import java.util.Optional;

import com.demo.model.Administrator;
import com.demo.model.Coordinator;
import com.demo.model.Notification;
import com.demo.model.Worker;
import com.demo.repositories.AdministratorRepository;
import com.demo.repositories.CoordinatorRepository;
import com.demo.repositories.WorkerRepository;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class NotificationController {

    private String server = "https://fcm.googleapis.com/fcm/send";
    private RestTemplate rest;
    private HttpHeaders headers;
    private HttpStatus status;
    
    @Autowired
    private WorkerRepository workerRepository;

    @Autowired
    private CoordinatorRepository coordinatorRepository;

    @Autowired
    private AdministratorRepository administratorRepository;

    public NotificationController() {
        this.rest = new RestTemplate();
        this.headers = new HttpHeaders();
        headers.add("Content-Type", "application/json");
        headers.add("Accept", "*/*");
        headers.add("Authorization", "key=AAAAkwKr74Q:APA91bHEeb-bbU0kWkqxIeUDkDHV-c59BCCOMthvVer31HZZAp7gwqpBbIuN2c_ln-GjReVIg_P8z5K6hvUbhHYgjOXQjrW3MMb88nYwe2WBWW8K-gasIQNvUx5GyXgbNbrrei2QRCns");
    }
    
    @PostMapping("/sendByDevice")
    public String sendNotification(@RequestBody String data) {
        HttpEntity<String> requestEntity = new HttpEntity<String>(data, headers);
        ResponseEntity<String> responseEntity = rest.exchange(server, HttpMethod.POST, requestEntity, String.class);
        this.setStatus(responseEntity.getStatusCode());
        return responseEntity.getBody();
        
    }

    @PostMapping("/sendByUser/{userId}")
    public ResponseEntity sendNotificationByUser(@RequestBody Notification data,@PathVariable(value = "userId") String userId) {
        Optional<Worker> worker = workerRepository.findById(userId);
        if(worker.isPresent()){
            if(worker.get().getDevices()!=null){
                for(String d : worker.get().getDevices()){
                    data.setTo(d);
                    JSONObject res = new JSONObject(data);
                    sendNotification(res.toString());
                }
                return ResponseEntity.ok(true);
            }
        }else{
            Optional<Administrator> administrator = administratorRepository.findById(userId);
            if(administrator.isPresent()){
                System.out.println(administrator.get().toString());
                if(administrator.get().getDevices()!=null){
                    for(String d : administrator.get().getDevices()){
                        data.setTo(d);
                        JSONObject res = new JSONObject(data);
                        sendNotification(res.toString());
                    }
                    return ResponseEntity.ok(true);
                }
            }else{
                Optional<Coordinator> coordinator = coordinatorRepository.findById(userId);
                if(coordinator.isPresent()){
                    if(coordinator.get().getDevices()!=null){
                        for(String d : coordinator.get().getDevices()){
                            data.setTo(d);
                            JSONObject res = new JSONObject(data);
                            sendNotification(res.toString());
                        }
                    }
                    return ResponseEntity.ok(true);
                }
            }
        }
        return ResponseEntity.ok(false);
        
    }

    public void setStatus(HttpStatus status) {
        this.status = status;
    } 
}