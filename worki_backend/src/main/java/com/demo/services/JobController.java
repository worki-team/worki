package com.demo.services;

import org.apache.catalina.connector.Response;
import org.bson.types.ObjectId;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
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
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.validation.Valid;
import javax.websocket.server.PathParam;

import com.demo.model.Applicant;
import com.demo.model.Event;
import com.demo.model.Job;
import com.demo.model.Worker;
import com.demo.repositories.ApplicantRepository;
import com.demo.repositories.EventRepository;
import com.demo.repositories.JobRepository;
import com.demo.repositories.WorkerRepository;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class JobController {

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private ApplicantRepository applicantRepository;

    @Autowired
    private WorkerRepository workerRepository;

    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private final MongoTemplate mongoTemplate;

    @Autowired
    public JobController(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
    }
    //EVENT
	@GetMapping("/job")
    public List<Job> getAllJobs() {
        return jobRepository.findAll();
    }

    @GetMapping("/search/job/{query}")
    public List<Job> searchJob(@PathVariable(value = "query") String query){
        return jobRepository.findByNameOrDescription(query);

    }

    @GetMapping("/applicant/jobId/{jobId}/workers")
    public ResponseEntity getWorkersApplicantsByJobId(@PathVariable(value = "jobId") String jobId){
        Optional<Applicant> applicant = applicantRepository.findByJobId(jobId);
        if(applicant.isPresent()){
            ArrayList<Worker> workers = new ArrayList<>();
            for (String value : applicant.get().getWorkersId()) {
                Optional <Worker> worker = workerRepository.findById(value);
                if(worker.isPresent()){
                    workers.add(worker.get());
                }
            }
            return ResponseEntity.ok().body(workers);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @GetMapping("/job/{jobId}/workers")
    public ResponseEntity getWorkersByJobId(@PathVariable(value = "jobId") String jobId){
        Optional<Job> job = jobRepository.findById(jobId);
        ArrayList<Worker> workers = new ArrayList<>();
        if(job.isPresent()){
            for (String value : job.get().getworkersId()) {
                Optional <Worker> worker = workerRepository.findById(value);
                if(worker.isPresent()){
                    workers.add(worker.get());
                }
            }
            return ResponseEntity.ok().body(workers);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @GetMapping("/job/{jobId}/registered")
    public List<Worker> getRegisteredWorkersByJobId(@PathVariable(value = "jobId") String jobId){
        Optional<Job> job = jobRepository.findById(jobId);
        ArrayList<Worker> workers = new ArrayList<>();
        if(job.isPresent()){
            for (String value : job.get().getRegisteredIds()) {
                Optional <Worker> worker = workerRepository.findById(value);
                if(worker.isPresent()){
                    workers.add(worker.get());
                }
            }
          //  return ResponseEntity.ok().body(workers);
        }
        return workers;
        //return (ResponseEntity) ResponseEntity.notFound();
    }

    @GetMapping("/job/{id}")
    public ResponseEntity getJobById(@PathVariable(value = "id") String jobId){
        Optional<Job> job = jobRepository.findById(jobId);
        if(job.isPresent()){
            return ResponseEntity.ok().body(job);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @PostMapping("/job")
    public Job addJob(@RequestBody Job job) {
        return jobRepository.save(job);
    }

    @PutMapping("/job/{id}")
    public ResponseEntity updateJob(@PathVariable(value = "id") String jobId, @Valid @RequestBody Job jobDetails) {
        Optional<Job> job = jobRepository.findById(jobId);
        if(job.isPresent()){
            BeanUtils.copyProperties(jobDetails,job.get());
            final Job updatedJob = jobRepository.save(job.get());
            return ResponseEntity.ok(true);
        }else{
            return ResponseEntity.ok(false);
        }
    }

    @DeleteMapping("/job/{id}")
    public ResponseEntity deleteJob(@PathVariable(value = "id") String jobId) {
        Optional<Job> job = jobRepository.findById(jobId);
        if(job.isPresent()){
            jobRepository.delete(job.get());
            return ResponseEntity.ok(true);
        }
        return (ResponseEntity) ResponseEntity.badRequest();
    }
    
    @GetMapping("/job/company/{id}")
    public List<Job> getAllJobsByCompany(@PathVariable(value = "id") ObjectId companyId) {
        //jobRepository.findByCompany(companyId);
        return jobRepository.findByCompanyId(companyId);
    }

    @GetMapping("/job/event/{id}")
    public List<Job> getAllJobsByEvent(@PathVariable(value = "id") ObjectId eventId) {
        //jobRepository.findByCompany(companyId);
        return jobRepository.findByEventId(eventId);
    }

    @GetMapping("/job/worker/{id}")
    public List<Job> getAllJobsByWorker(@PathVariable(value = "id") String workerId) {
        //jobRepository.findByCompany(companyId);
        return jobRepository.findByWorkersIdContaining(workerId);
    }

    @GetMapping("/job/name/{name}")
    public List<Job> getAllJobsByName(@PathVariable(value = "name") String name) {
        //jobRepository.findByCompany(companyId);
        return jobRepository.findByName(name);
    }

    
    @GetMapping("/job/state/{state}")
    public List<Job> getAllJobsByState(@PathVariable(value = "state") boolean state) {
        //jobRepository.findByCompany(companyId);
        return jobRepository.findByState(state);
    }
    
    
    //**REVISAR**/
    @GetMapping("/job/name_description/{value}")
    public List<Job> getAllJobsByValue(@PathVariable(value = "value") String value) {
        //jobRepository.findByCompany(companyId);
        System.out.println("Query "+value);
        return jobRepository.findByName(value,value,value);
    }

    @GetMapping("/job/functions/{func}")
    public List<Job> getAllJobsByFunctions(@PathVariable(value = "func") String func) {
        //jobRepository.findByCompany(companyId);
        return jobRepository.findByFunctions(func);
    }

    @GetMapping("/job/coordinator/{coordinatorId}")
    public List<Job> getJobsByCoordinator(@PathVariable(value = "coordinatorId") String coordinatorId){
        List<Event> events = eventRepository.findByCoordinatorsIdContaining(coordinatorId);
        ArrayList<Job> jobs = new ArrayList<>();
        if(!events.isEmpty()){
            for (Event e : events) {
                List<Job> j = jobRepository.findByEventId(e.getIdObjectId());
                jobs.addAll(j);
            }
        }
        return jobs;
    }

    @GetMapping("/job/filter")
    public List<Job> getJobsByQuery(
        @PathParam("name") String name,
        @PathParam("description") String description,
        @PathParam("startSalary") float startSalary,
        @PathParam("endSalary") float endSalary,
        @PathParam("initialDate") Date initialDate,
        @PathParam("finalDate") Date finalDate,
        @PathParam("duration") String duration,
        @PathParam("city") String city,
        @PathParam("company") String company,
        @PathParam("functions") String functions,
        @PathParam("state") String state,
        @PathParam("companyId") String companyId

    ){  
        List<AggregationOperation> list = new ArrayList<AggregationOperation>();
        
        
        list.add(Aggregation.match(Criteria.where("salary").gt(startSalary).lt(endSalary)));
        
        if(name != null){
            list.add(Aggregation.match(Criteria.where("name").regex(name,"i")));
        }
        if(description != null){
            list.add(Aggregation.match(Criteria.where("description").regex(description,"i")));
        }
        if(functions != null){
            String[] func = functions.split(":");
            System.out.println(functions);
            for (String f : func){
                list.add(Aggregation.match(Criteria.where("functions").in(f, "i")));
            }
        }
        if(initialDate != null){
            list.add(Aggregation.match(Criteria.where("initialDate").gte(initialDate)));
        }
        if(finalDate != null){
            list.add(Aggregation.match(Criteria.where("initialDate").lt(finalDate)));
        }
        if(duration != null){
            list.add(Aggregation.match(Criteria.where("duration").is(Integer.parseInt(duration))));
        }
        if(state != null){
            boolean s = false;
            if(state.equals("true")){
                s = true;
            }
            list.add(Aggregation.match(Criteria.where("state").is(s)));
        }
        if(companyId != null){
            list.add(Aggregation.match(Criteria.where("companyId").is(companyId)));
        }
        list.add(Aggregation.sort(Sort.Direction.ASC, "initialDate"));
        TypedAggregation<Job> agg = Aggregation.newAggregation(Job.class, list);
        return mongoTemplate.aggregate(agg, Job.class, Job.class).getMappedResults();
        
    }

    @GetMapping("/report")
    public List<Worker> getReportWorkers(
        @PathParam("jobId") String jobId,
        @PathParam("eventId") String eventId,
        @PathParam("companyId") String companyId,
        @PathParam("initialDate") Date initialDate,
        @PathParam("finalDate") Date finalDate
    ){  
        List<AggregationOperation> list = new ArrayList<AggregationOperation>();
        List<Worker> workers = new ArrayList<Worker>();

        if(companyId != null){
            System.out.println("Company");
            System.out.println(companyId);
            ObjectId companyObjectId = new ObjectId(companyId);
            
            list.add(Aggregation.match(Criteria.where("companyId").is(companyObjectId)));
            if(initialDate != null){
                list.add(Aggregation.match(Criteria.where("initialDate").gte(initialDate)));
            }
            if(finalDate != null){
                list.add(Aggregation.match(Criteria.where("initialDate").lt(finalDate)));
            }
        }else{
            if(eventId != null){
                System.out.println("Event");
                System.out.println(eventId);
                ObjectId eventObjectId = new ObjectId(eventId);
                list.add(Aggregation.match(Criteria.where("eventId").is(eventObjectId)));
            }else{
                if(jobId!=null){
                    System.out.println("Job");
                    System.out.println(jobId);
                    ObjectId jobObjectId = new ObjectId(jobId);
                    list.add(Aggregation.match(Criteria.where("id").is(jobObjectId)));
                }
            }
        }
        list.add(Aggregation.sort(Sort.Direction.ASC, "initialDate"));
        TypedAggregation<Job> agg = Aggregation.newAggregation(Job.class, list);
        List<Job> jobs = mongoTemplate.aggregate(agg, Job.class, Job.class).getMappedResults();
        List<String> workerIds = new ArrayList<String>();
        for(Job j : jobs){
            List<Worker> auxWorkerList = getRegisteredWorkersByJobId(j.getId());
            for(Worker w : auxWorkerList){
                if(!workerIds.contains(w.getId())){
                    List<String> reportJobs = new ArrayList<String>();
                    reportJobs.add(j.getName());
                    w.setReportJobs(reportJobs);
                    w.setReportSalary(w.getReportSalary()+j.getSalary());
                    workerIds.add(w.getId());
                    workers.add(w);
                }else{
                    Worker auxWorker = workers.get(workerIds.indexOf(w.getId()));
                    if(auxWorker.getId().equals(w.getId())){
                        List<String> reportJobs = workers.get(workerIds.indexOf(w.getId())).getReportJobs();
                        reportJobs.add(j.getName());
                        workers.get(workerIds.indexOf(w.getId())).setReportJobs(reportJobs);
                        workers.get(workerIds.indexOf(w.getId())).setReportSalary(workers.get(workerIds.indexOf(w.getId())).getReportSalary()+j.getSalary());
                    }
                }

            }
            //workers.addAll(auxWorkerList);
            
        }


        return workers;
    }   

}