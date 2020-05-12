package com.demo.services;

import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.bson.types.ObjectId;
import org.json.JSONObject;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.data.web.SpringDataWebProperties.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationOperation;
import org.springframework.data.mongodb.core.aggregation.TypedAggregation;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import javax.websocket.server.PathParam;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.validation.Valid;

import com.demo.model.Administrator;
import com.demo.model.Coordinator;
import com.demo.model.PhysicalProfile;
import com.demo.model.User;
import com.demo.model.Worker;
import com.demo.repositories.AdministratorRepository;
import com.demo.repositories.CoordinatorRepository;
import com.demo.repositories.UserRepository;
import com.demo.repositories.WorkerRepository;
import com.demo.utils.ContextureType;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private WorkerRepository workerRepository;

    @Autowired
    private CoordinatorRepository coordinatorRepository;

    @Autowired
    private AdministratorRepository administratorRepository;

    @Autowired
    private final MongoTemplate mongoTemplate;

    @Autowired
    public UserController(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
    }

    // WORKER
    @PostMapping("/login")
    public ResponseEntity login(@Valid @RequestBody String body)
            throws JsonParseException, JsonMappingException, IOException {
        
        ObjectMapper objectMapper = new ObjectMapper();
        User userBody = objectMapper.readValue(body,User.class);
        
        String userEmail = userBody.getEmail();
        String password  = userBody.getPassword();
        Optional<Worker> optionalWorkers = workerRepository.findWorkerByEmail(userEmail);

        if(optionalWorkers.isPresent() && optionalWorkers.get().getPassword().equals(password)){
            return ResponseEntity.ok().body(optionalWorkers.get());
        }else {
            Optional<Coordinator> optionalCoordinators = coordinatorRepository.findCoordinatorByEmail(userEmail);
            if(optionalCoordinators.isPresent() && optionalCoordinators.get().getPassword().equals(password)){
                return ResponseEntity.ok().body(optionalCoordinators.get());
            }else{
                Optional<Administrator> optionalAdministrators = administratorRepository.findAdministratorByEmail(userEmail);
                if(optionalAdministrators.isPresent() && optionalAdministrators.get().getPassword().equals(password)){
                    return ResponseEntity.ok().body(optionalAdministrators.get());
                }
            }
        }
        JSONObject response = new JSONObject();
        response.put("message","Datos inválidos");
        return ResponseEntity.ok(response.toMap());
       
    }

    @PreAuthorize("hasAnyRole('COORDINATOR','ADMINISTRATOR')")
    @GetMapping("/secured/worker")
    public List<Worker> getAllWorkersSecured() {
        return workerRepository.findAll();
    }

	@GetMapping("/worker")
    public List<Worker> getAllWorkers() {
        return workerRepository.findAll();
    }

    @GetMapping("/worker/{id}")
    public ResponseEntity getWorkerById(@PathVariable(value = "id") String workerId){
        Optional<Worker> worker = workerRepository.findById(workerId);
        if(worker.isPresent()){
            return ResponseEntity.ok().body(worker);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }


    @PostMapping("/worker")
    public ResponseEntity addWorker(@RequestBody Worker worker) {
        return ResponseEntity.ok(workerRepository.save(worker));
    }

    @PutMapping("/worker/{id}")
    public ResponseEntity updateWorker(@PathVariable(value = "id") String workerId, @Valid @RequestBody Worker workerDetails) {
        Optional<Worker> worker = workerRepository.findById(workerId);
        if(worker.isPresent()){
            BeanUtils.copyProperties(workerDetails,worker.get());
            final Worker updatedWorker = workerRepository.save(worker.get());
            return ResponseEntity.ok().body(updatedWorker);
        }else{
            return ResponseEntity.ok(false);
        }
    }

    @DeleteMapping("/worker/{id}")
    public ResponseEntity deleteWorker(@PathVariable(value = "id") String workerId) {
        Optional<Worker> worker = workerRepository.findById(workerId);
        if(worker.isPresent()){
            workerRepository.delete(worker.get());
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }
    
    // COORDINATOR

    @GetMapping("/coordinator")
    public List<Coordinator> getAllCoordinators() {
        return coordinatorRepository.findAll();
    }

    @GetMapping("/coordinator/{id}")
    public ResponseEntity getCoordinatorById(@PathVariable(value = "id") String coordinatorId){
        Optional<Coordinator> coordinator = coordinatorRepository.findById(coordinatorId);
        if(coordinator.isPresent()){
            return ResponseEntity.ok().body(coordinator);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @GetMapping("/coordinator/companyId/{id}")
    public List<Coordinator> getAllCoordinatorsByCompany(@PathVariable(value = "id") ObjectId companyId){
        return coordinatorRepository.findByCompanyId(companyId);
    }

    @PostMapping("/coordinator")
    public ResponseEntity addCoordinator(@RequestBody Coordinator coordinator) {
        JSONObject response = new JSONObject();
        Optional<Coordinator> exists = coordinatorRepository.findCoordinatorByEmail(coordinator.getEmail());
        if(exists.isPresent()){
            response.put("message","Ya se ha utilizado el email");
            return ResponseEntity.ok(response.toMap());
        }
        
        return ResponseEntity.ok(coordinatorRepository.save(coordinator));
    }

    @PutMapping("/coordinator/{id}")
    public ResponseEntity updateCoordinator(@PathVariable(value = "id") String coordinatorId, @Valid @RequestBody Coordinator coordinatorDetails) {
        Optional<Coordinator> coordinator = coordinatorRepository.findById(coordinatorId);
        if(coordinator.isPresent()){
            BeanUtils.copyProperties(coordinatorDetails,coordinator.get());
            final Coordinator updatedCoordinator = coordinatorRepository.save(coordinator.get());
            return ResponseEntity.ok().body(updatedCoordinator);
        }else{
            return ResponseEntity.ok(false);
        }
    }

    @DeleteMapping("/coordinator/{id}")
    public ResponseEntity deleteCoordinator(@PathVariable(value = "id") String coordinatorId) {
        Optional<Coordinator> coordinator = coordinatorRepository.findById(coordinatorId);
        if(coordinator.isPresent()){
            coordinatorRepository.delete(coordinator.get());
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }

    // ADMINISTRATOR

    @GetMapping("/administrator")
    public List<Administrator> getAllAdministrators() {
        return administratorRepository.findAll();
    }

    @GetMapping("/administrator/{id}")
    public ResponseEntity getAdministratorById(@PathVariable(value = "id") String administratorId){
        Optional<Administrator> administrator = administratorRepository.findById(administratorId);
        if(administrator.isPresent()){
            return ResponseEntity.ok().body(administrator);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }
/*
    @GetMapping("/administrator/companyId")
    public ResponseEntity getAdministratorByCompanyId(@RequestParam(required = true) String companyId){
        Optional<Administrator> administrator = administratorRepository.findAdministratorByCompanyId(companyId);
        if(administrator.isPresent()){
            return ResponseEntity.ok().body(administrator);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }
*/

    @PostMapping("/administrator")
    public ResponseEntity addAdministrator(@RequestBody Administrator administrator) {
        
        JSONObject response = new JSONObject();
        Optional<Administrator> exists = administratorRepository.findAdministratorByEmail(administrator.getEmail());
        if(exists.isPresent()){
            response.put("message","Ya se ha utilizado el email");
            return ResponseEntity.ok(response.toMap());
        }
        
        return ResponseEntity.ok(administratorRepository.save(administrator));
    }

    @PutMapping("/administrator/{id}")
    public ResponseEntity updateAdministrator(@PathVariable(value = "id") String administratorId, @Valid @RequestBody Administrator administratorDetails) {
        Optional<Administrator> administrator = administratorRepository.findById(administratorId);
        if(administrator.isPresent()){
            BeanUtils.copyProperties(administratorDetails,administrator.get());
            final Administrator updatedAdministrator = administratorRepository.save(administrator.get());
            return ResponseEntity.ok().body(updatedAdministrator);
        }else{
            return ResponseEntity.ok(false);
        }
    }

    @DeleteMapping("/administrator/{id}")
    public ResponseEntity deleteAdministrator(@PathVariable(value = "id") String administratorId) {
        Optional<Administrator> administrator = administratorRepository.findById(administratorId);
        if(administrator.isPresent()){
            administratorRepository.delete(administrator.get());
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }
    
    @GetMapping("/user/{fireUID}")
    public ResponseEntity getUserByFireUID( @PathVariable(value = "fireUID") String fireUID ) {
        Optional<Worker> optionalWorkers = workerRepository.findWorkerByFireUid(fireUID);

        if(optionalWorkers.isPresent()){
            return ResponseEntity.ok().body(optionalWorkers.get());
        }else {
            Optional<Coordinator> optionalCoordinators = coordinatorRepository.findCoordinatorByFireUid(fireUID);
            if(optionalCoordinators.isPresent()){
                return ResponseEntity.ok().body(optionalCoordinators.get());
            }else{
                Optional<Administrator> optionalAdministrators = administratorRepository.findAdministratorByFireUid(fireUID);
                if(optionalAdministrators.isPresent()){
                    return ResponseEntity.ok().body(optionalAdministrators.get());
                }
            }
        }
        JSONObject response = new JSONObject();
        response.put("message","Datos inválidos");
        return ResponseEntity.ok(response.toMap());
    }

    @GetMapping("/worker/filter")
    public List<Worker> getJobsByQuery(
        @PathParam("name") String name,
        @PathParam("city") String city,
        @PathParam("gender") String gender,
        @PathParam("startAge") int startAge,
        @PathParam("endAge") int endAge,
        @PathParam("isActive") String isActive,
        @PathParam("description") String description,
        @PathParam("nationality") String nationality,
        @PathParam("ocupation") String ocupation,
        @PathParam("languages") String languages,
        @PathParam("aptitudes") String aptitudes,
        @PathParam("contexture") String contexture,
        @PathParam("eyeColor") String eyeColor,
        @PathParam("hairColor") String hairColor,
        @PathParam("hairType") String hairType,
        @PathParam("skinColor") String skinColor,
        @PathParam("height") String height,
        @PathParam("weight") String weight,
        @PathParam("pantSize") String pantSize,
        @PathParam("shirtSize") String shirtSize,
        @PathParam("shoesSize") String shoesSize
    ){  
        PhysicalProfile physicalProfile = new PhysicalProfile();
        List<AggregationOperation> list = new ArrayList<AggregationOperation>();
        
        list.add(Aggregation.match(Criteria.where("age").gt(startAge).lt(endAge)));
        if(name != null){
            list.add(Aggregation.match(Criteria.where("name").regex(name,"i")));
        }
        if(city != null){
            list.add(Aggregation.match(Criteria.where("city").regex(city,"i")));
        }

        if(gender != null){
            list.add(Aggregation.match(Criteria.where("gender").is(gender)));
        }

        if(isActive != null){
            boolean s = false;
            if(isActive.equals("true")){
                s = true;
            }
            list.add(Aggregation.match(Criteria.where("isActive").is(s)));
        }
        if(description != null){
            list.add(Aggregation.match(Criteria.where("description").regex(description,"i")));
        }

        if(languages != null){
            list.add(Aggregation.match(Criteria.where("languages").in(languages, "i")));
        }
        if(aptitudes != null){
            list.add(Aggregation.match(Criteria.where("aptitudes").in(aptitudes, "i")));
        }
        if(contexture != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.contexture").is(contexture)));
        }
        if(eyeColor != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.eyeColor").is(eyeColor)));
        }
        if(hairColor != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.hairColor").is(hairColor)));
        }
        if(hairType != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.hairType").is(hairType)));
        }
        if(skinColor != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.skinColor").is(skinColor)));
        }
        if(height != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.height").is(Integer.parseInt(height))));
        }
        if(weight != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.weight").is(Integer.parseInt(weight))));
        }
        if(pantSize != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.pantSize").is(Integer.parseInt(pantSize))));
        }
        if(shirtSize != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.shirtSize").is(shirtSize)));
        }
        if(shoesSize != null){
            list.add(Aggregation.match(Criteria.where("physicalProfile.shoesSize").is(Integer.parseInt(shoesSize))));
        }
        


        TypedAggregation<Worker> agg = Aggregation.newAggregation(Worker.class, list);
        return mongoTemplate.aggregate(agg, Worker.class, Worker.class).getMappedResults();
        
    }

}