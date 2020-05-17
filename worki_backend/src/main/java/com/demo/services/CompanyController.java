package com.demo.services;

import org.bson.types.ObjectId;
import org.json.JSONObject;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import javax.validation.Valid;

import com.demo.model.Administrator;
import com.demo.model.Company;
import com.demo.model.Event;
import com.demo.model.Job;
import com.demo.model.Worker;
import com.demo.repositories.AdministratorRepository;
import com.demo.repositories.CompanyRepository;
import com.demo.repositories.EventRepository;
import com.demo.repositories.JobRepository;
import com.demo.repositories.WorkerRepository;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

import java.text.DateFormatSymbols;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class CompanyController {

    @Autowired
    private CompanyRepository companyRepository;
    @Autowired
    private AdministratorRepository administratorRepository;
    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private JobRepository jobRepository;
    @Autowired
    private WorkerRepository workerRepository;

    @GetMapping("/company")
    public List<Company> getAllCompanies() {
        return companyRepository.findAll();
    }

    @GetMapping("/company/{id}")
    public ResponseEntity getCompanyById(@PathVariable(value = "id") String companyId) {
        Optional<Company> company = companyRepository.findById(companyId);
        if (company.isPresent()) {
            return ResponseEntity.ok().body(company);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @GetMapping("/administrator/{id}/company")
    public ResponseEntity getCompanyOfCoordinator(@PathVariable(value = "id") String administratorId) {
        Optional<Administrator> administrator = administratorRepository.findById(administratorId);
        Optional<Company> company = companyRepository.findById(administrator.get().getCompanyId());
        if (company.isPresent()) {
            return ResponseEntity.ok().body(company);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @PostMapping("/company")
    public Company addCompany(@RequestBody Company company) {
        return companyRepository.save(company);
    }

    @PutMapping("/company/{id}")
    public ResponseEntity updateCompany(@PathVariable(value = "id") String companyId,
            @Valid @RequestBody Company companyDetails) {
        Optional<Company> company = companyRepository.findById(companyId);
        if (company.isPresent()) {
            BeanUtils.copyProperties(companyDetails, company.get());
            final Company updatedCompany = companyRepository.save(company.get());
            return ResponseEntity.ok().body(updatedCompany);
        } else {
            return ResponseEntity.ok(false);
        }
    }

    @DeleteMapping("/company/{id}")
    public ResponseEntity deleteCompany(@PathVariable(value = "id") ObjectId companyId) {
        Optional<Company> company = companyRepository.findById(companyId.toHexString());
        if (company.isPresent()) {
            List<Event> events = eventRepository.findByCompanyId(companyId);
            for (Event event : events) {
                eventRepository.delete(event);
            }
            List<Job> jobs = jobRepository.findByCompanyId(companyId);
            for (Job job : jobs) {
                jobRepository.delete(job);
            }
            companyRepository.delete(company.get());
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }

    @GetMapping("/company/{id}/statistics/salary/year")
    public ResponseEntity getSalaryStatisticsPerYear(@PathVariable(value = "id") ObjectId companyId) {
        Map<String, Float> map = new HashMap<String, Float>();
        List<Job> jobs = jobRepository.findByCompanyId(companyId);
        for (Job job : jobs) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(job.getFinalDate());
            String year = Integer.toString(cal.get(Calendar.YEAR));
            if (map.get(year) == null) {
                map.put(year, job.getSalary()*job.getRegisteredIds().size());
            } else {
                Float currentTotal = map.get(year);
                map.put(year, currentTotal + job.getSalary()*job.getRegisteredIds().size());
            }
        }
        return ResponseEntity.ok(map);
    }

    @GetMapping("/company/{id}/statistics/salary/month")
    public ResponseEntity getSalaryStatisticsPerMonth(@PathVariable(value = "id") ObjectId companyId) {
        Map<String, Float> map = new HashMap<String, Float>();
        List<Job> jobs = jobRepository.findByCompanyId(companyId);
        for (Job job : jobs) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(job.getFinalDate());
            String month = new DateFormatSymbols().getMonths()[cal.get(Calendar.MONTH) - 1];
            if (map.get(month) == null) {
                map.put(month, job.getSalary()*job.getRegisteredIds().size());
            } else {
                Float currentTotal = map.get(month);
                map.put(month, currentTotal + job.getSalary()*job.getRegisteredIds().size());
            }
        }
        return ResponseEntity.ok(map);
    }

    @GetMapping("/company/{id}/statistics/gender")
    public ResponseEntity getGenderStatistics(@PathVariable(value = "id") ObjectId companyId) {
        Map<String, Integer> map = new HashMap<String, Integer>();
        List<Job> jobs = jobRepository.findByCompanyId(companyId);
        Set<String> workersId = new HashSet<String>();
        for (Job job : jobs) {
            for (String id : job.getRegisteredIds()) {
                Optional<Worker> worker = workerRepository.findById(id);
                if (worker.isPresent() && !workersId.contains(worker.get().getId())) {
                    workersId.add(worker.get().getId());
                    String gender = worker.get().getGender();
                    if (map.get(gender) == null) {
                        map.put(gender, 1);
                    } else {
                        Integer currentTotal = map.get(gender);
                        map.put(gender, currentTotal + 1);
                    }
                }
            }

        }
        return ResponseEntity.ok(map);
    }

    @GetMapping("/company/{id}/statistics/age")
    public ResponseEntity getAgeStatistics(@PathVariable(value = "id") ObjectId companyId) {
        Map<String, Integer> map = new HashMap<String, Integer>();
        List<Job> jobs = jobRepository.findByCompanyId(companyId);
        Set<String> workersId = new HashSet<String>();
        for (Job job : jobs) {
            for (String id : job.getRegisteredIds()) {
                Optional<Worker> worker = workerRepository.findById(id);
                if (worker.isPresent() && !workersId.contains(worker.get().getId())) {
                    workersId.add(worker.get().getId());
                    int age = worker.get().getAge();
                    String range = "";
                    if (age > 18 && age <= 24) {
                        range = "18-24";
                    } else if (age > 25 && age <= 39) {
                        range = "25-39";
                    } else if (age >= 40 && age <= 59) {
                        range = "40-59";
                    } else if (age > 60) {
                        range = ">60";
                    }
                    if (map.get(range) == null) {
                        map.put(range, 1);
                    } else {
                        Integer currentTotal = map.get(range);
                        map.put(range, currentTotal + 1);
                    }
                }
            }

        }
        return ResponseEntity.ok(map);
    }
}