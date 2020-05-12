package com.demo.services;

import org.bson.types.ObjectId;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
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
import java.util.List;
import java.util.Optional;

import javax.validation.Valid;

import com.demo.model.Coordinator;
import com.demo.model.Event;
import com.demo.model.Payroll;
import com.demo.repositories.CoordinatorRepository;
import com.demo.repositories.EventRepository;
import com.demo.repositories.PayrollRepository;
import com.fasterxml.jackson.databind.deser.impl.ObjectIdReader;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class EventController {

    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private PayrollRepository payrollRepository;

    @Autowired
    private CoordinatorRepository coordinatorRepository;


    //**EVENT**//
	@GetMapping("/event")
    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }

    @GetMapping("/event/{id}")
    public ResponseEntity getEventById(@PathVariable(value = "id") String eventId){
        Optional<Event> event = eventRepository.findById(eventId);
        if(event.isPresent()){
            return ResponseEntity.ok().body(event);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    

    @PostMapping("/event")
    public Event addEvent(@RequestBody Event event) {
        
        return eventRepository.save(event);
    }

    @PutMapping("/event/{id}")
    public ResponseEntity updateEvent(@PathVariable(value = "id") String eventId, @Valid @RequestBody Event eventDetails) {
        Optional<Event> event = eventRepository.findById(eventId);
        if(event.isPresent()){
            BeanUtils.copyProperties(eventDetails,event.get());
            final Event updatedWorker = eventRepository.save(event.get());
            return ResponseEntity.ok(true);
        }else{
            return ResponseEntity.ok(false);
        }
    }

    @DeleteMapping("/event/{id}")
    public ResponseEntity deleteEvent(@PathVariable(value = "id") String eventId) {
        Optional<Event> event = eventRepository.findById(eventId);
        if(event.isPresent()){
            eventRepository.delete(event.get());
            return ResponseEntity.ok(true);
        }
        return (ResponseEntity) ResponseEntity.badRequest();
    }
    
    @GetMapping("/event/company/{id}")
    public List<Event> getAllEventsByCompany(@PathVariable(value = "id") ObjectId companyId) {
        //eventRepository.findByCompany(companyId);
        return eventRepository.findByCompanyId(companyId);
    }

    @GetMapping("/event/coordinator/{id}")
    public List<Event> getAllEventsByCoordinator(@PathVariable(value = "id") String coordinatorId) {
        //eventRepository.findByCompany(companyId);
        return eventRepository.findByCoordinatorsIdContaining(coordinatorId);
    }

    @GetMapping("/event/{id}/coordinator")
    public ResponseEntity getCoordinatorByEvent(@PathVariable(value = "id") String eventId){
        Optional<Event> event = eventRepository.findById(eventId);
        ArrayList<Coordinator> coordinators = new ArrayList<>();
        if(event.isPresent()){
            for (String value : event.get().getCoordinatorsId()) {
                Optional <Coordinator> coordinator = coordinatorRepository.findById(value);
                if(coordinator.isPresent()){
                    coordinators.add(coordinator.get());
                }
            }
            return ResponseEntity.ok().body(coordinators);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }


    @GetMapping("/event/type/{type}")
    public List<Event> getAllEventsByType(@PathVariable(value = "type") String type) {
        //eventRepository.findByCompany(companyId);
        return eventRepository.findByType(type);
    }

    @GetMapping("/event/name/{name}")
    public List<Event> getAllEventsByName(@PathVariable(value = "name") String name) {
        //eventRepository.findByCompany(companyId);
        System.out.println("Query "+name);
        return eventRepository.findByName(name);
    }




    //** PAYROLL **/

    @GetMapping("/event/{id}/payroll")
    public List<Payroll> getAllPayrollsByEvent(@PathVariable(value = "id") ObjectId eventId) {
        return payrollRepository.findByEventId(eventId);
    }

    @GetMapping("event/payroll/{id}")
    public ResponseEntity getPayrollById(@PathVariable(value = "id") String Id){
        Optional<Payroll> payroll = payrollRepository.findById(Id);
        if(payroll.isPresent()){
            return ResponseEntity.ok().body(payroll);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    

    @PostMapping("/event/payroll")
    public Payroll addPayroll(@RequestBody Payroll payroll) {
        
        return payrollRepository.save(payroll);
    }

    @PutMapping("/event/payroll/{id}")
    public ResponseEntity updatePayroll(@PathVariable(value = "id") String payrollId, @Valid @RequestBody Payroll payrollDetails) {
        Optional<Payroll> payroll = payrollRepository.findById(payrollId);
        if(payroll.isPresent()){
            BeanUtils.copyProperties(payrollDetails,payroll.get());
            final Payroll updatedPayroll = payrollRepository.save(payroll.get());
            return ResponseEntity.ok(true);
        }else{
            return ResponseEntity.ok(false);
        }
    }

    @DeleteMapping("/event/payroll/{id}")
    public ResponseEntity deletePayroll(@PathVariable(value = "id") String payrollId) {
        Optional<Payroll> payroll = payrollRepository.findById(payrollId);
        if(payroll.isPresent()){
            payrollRepository.delete(payroll.get());
            return ResponseEntity.ok(true);
        }
        return (ResponseEntity) ResponseEntity.badRequest();
    }

}