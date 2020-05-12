package com.demo.resource;

import com.demo.model.Administrator;
import com.demo.model.Coordinator;
import com.demo.model.CustomUserDetails;
import com.demo.model.User;
import com.demo.model.Worker;
import com.demo.repositories.AdministratorRepository;
import com.demo.repositories.CoordinatorRepository;
import com.demo.repositories.WorkerRepository;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private CoordinatorRepository coordinatorRepository;

    @Autowired
    private WorkerRepository workerRepository;

    @Autowired
    private AdministratorRepository administratorRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        Optional<Worker> optionalWorkers = workerRepository.findWorkerByEmail(username);
        Optional<Administrator> optionalAdministrators = administratorRepository.findAdministratorByEmail(username);
        Optional<Coordinator> optionalCoordinators = coordinatorRepository.findCoordinatorByEmail(username);

        User user = new User();

        if(optionalWorkers.isPresent()){
            BeanUtils.copyProperties(optionalWorkers.get(),user);
            CustomUserDetails customUserDetails = new CustomUserDetails(user);
            return customUserDetails;
        }else if(optionalAdministrators.isPresent()){
            BeanUtils.copyProperties(optionalAdministrators.get(),user);
            CustomUserDetails customUserDetails = new CustomUserDetails(user);
            return customUserDetails;
        }
        else if(optionalCoordinators.isPresent()){
            BeanUtils.copyProperties(optionalCoordinators.get(),user);
            CustomUserDetails customUserDetails = new CustomUserDetails(user);
            return customUserDetails;
        }
        else{
            return (UserDetails) optionalCoordinators.orElseThrow(() -> new UsernameNotFoundException("Username not found"));
        }
    }
}