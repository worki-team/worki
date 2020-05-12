package com.demo.services;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.validation.Valid;

import com.demo.model.Applicant;
import com.demo.model.Job;
import com.demo.repositories.ApplicantRepository;
import com.demo.repositories.JobRepository;
import com.demo.repositories.UserRepository;
import com.demo.repositories.WorkerRepository;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class ApplicantController {

    @Autowired
    private ApplicantRepository applicantRepository;

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private WorkerRepository workerRepository;

    @GetMapping("/applicant")
    public List<Applicant> getAllApplicants() {
        return applicantRepository.findAll();
    }

    @GetMapping("/applicant/{id}")
    public ResponseEntity getApplicantById(@PathVariable(value = "id") String applicantId) {
        Optional<Applicant> applicant = applicantRepository.findById(applicantId);
        if (applicant.isPresent()) {
            return ResponseEntity.ok().body(applicant);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @GetMapping("/applicant/jobId/{jobId}")
    public ResponseEntity getApplicantByJobId(@PathVariable(value = "jobId") String jobId) {
        Optional<Applicant> applicant = applicantRepository.findByJobId(jobId);
        if (applicant.isPresent()) {
            return ResponseEntity.ok().body(applicant);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

    @PostMapping("/applicant")
    public Applicant addApplicant(@RequestBody Applicant applicant) {
        return applicantRepository.save(applicant);
    }

    @PutMapping("/applicant/{id}")
    public ResponseEntity updateApplicant(@PathVariable(value = "id") String applicantId,
            @Valid @RequestBody Applicant applicantDetails) {
        Optional<Applicant> applicant = applicantRepository.findById(applicantId);
        if (applicant.isPresent()) {
            BeanUtils.copyProperties(applicantDetails, applicant.get());
            final Applicant updatedApplicant = applicantRepository.save(applicant.get());
            return ResponseEntity.ok().body(updatedApplicant);
        } else {
            return ResponseEntity.ok(false);
        }
    }

    @PutMapping("/applicant/{id}/{workerId}")
    public ResponseEntity addWorkerToApplicant(@PathVariable(value = "id") String applicantId,
            @PathVariable(value = "workerId") String workerId) {
        Optional<Applicant> applicant = applicantRepository.findById(applicantId);
        if (applicant.isPresent()) {
                if (applicant.get().getWorkersId().size() + 1 <= applicant.get().getMaxWorkers()) {
                    applicant.get().getWorkersId().add(workerId);
                    final Applicant updatedApplicant = applicantRepository.save(applicant.get());
                    return ResponseEntity.ok().body(updatedApplicant);
                }
        }
        return ResponseEntity.ok(false);

    }

    @DeleteMapping("/applicant/{id}")
    public ResponseEntity deleteApplicant(@PathVariable(value = "id") String applicantId) {
        Optional<Applicant> applicant = applicantRepository.findById(applicantId);
        if (applicant.isPresent()) {
            applicantRepository.delete(applicant.get());
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }

    @GetMapping("/applicant/workerJobs/{workerId}")
    public ResponseEntity getApplicantByWorkerId(@PathVariable(value = "workerId") String workerId) {
        List<Applicant> applicants = applicantRepository.findByWorkersIdContaining(workerId);
        ArrayList<Job> workerJobs = new ArrayList<>();
        if (!applicants.isEmpty()) {
            for (Applicant a : applicants) {
                Optional<Job> job = jobRepository.findById(a.getJobId());
                if (job.isPresent()) {
                    workerJobs.add(job.get());
                }
            }
        }
        if (workerRepository.findById(workerId).isPresent()) {
            return ResponseEntity.ok().body(workerJobs);
        }
        return (ResponseEntity) ResponseEntity.notFound();
    }

}