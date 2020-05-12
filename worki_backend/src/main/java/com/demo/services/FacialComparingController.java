
package com.demo.services;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.rekognition.AmazonRekognition;
import com.amazonaws.services.rekognition.AmazonRekognitionClientBuilder;
import com.amazonaws.services.rekognition.model.BoundingBox;
import com.amazonaws.services.rekognition.model.CompareFacesMatch;
import com.amazonaws.services.rekognition.model.CompareFacesRequest;
import com.amazonaws.services.rekognition.model.CompareFacesResult;
import com.amazonaws.services.rekognition.model.ComparedFace;
import com.amazonaws.services.rekognition.model.Image;
import com.amazonaws.util.IOUtils;
import com.demo.model.FacesCompare;
import com.demo.model.Worker;
import com.demo.repositories.WorkerRepository;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * FacialComparing
 */
@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class FacialComparingController {
    @Autowired
    private WorkerRepository workerRepository;

    @PostMapping("/facescomparing")
    public ResponseEntity facescomparing(@RequestBody FacesCompare facesCompare) throws IOException {
        Float similarityThreshold = facesCompare.getSimilarityThreshold();
        Map<String, Float> map = new HashMap<String, Float>();
        List<Worker> workers = workerRepository.findAll();
        URL sourceImage = new URL(facesCompare.getSourceImage());
        for (int i = 0; i < workers.size(); i++) {

            if (workers.get(i).getProfilePic().length() > 1) {
                System.out.println(i);
                System.out.println(workers.get(i).getProfilePic().length());

                URL targetImage = new URL(workers.get(i).getProfilePic());

                ByteBuffer sourceImageBytes = null;
                ByteBuffer targetImageBytes = null;

                BasicAWSCredentials awsCreds = new BasicAWSCredentials(System.getenv("aws_access_key_id"),
                        System.getenv("aws_secret_access_key"));
                AmazonRekognition rekognitionClient = AmazonRekognitionClientBuilder.standard()
                        .withCredentials(new AWSStaticCredentialsProvider(awsCreds)).withRegion(System.getenv("region"))
                        .build(); 

                ByteArrayOutputStream output = new ByteArrayOutputStream();
                URLConnection conn = sourceImage.openConnection();
                conn.setRequestProperty("User-Agent", "Firefox");

                try (InputStream inputStream = conn.getInputStream()) {
                    int n = 0;
                    byte[] buffer = new byte[1024];
                    while (-1 != (n = inputStream.read(buffer))) {
                        output.write(buffer, 0, n);
                    }
                }

                byte[] img = output.toByteArray();
                sourceImageBytes = ByteBuffer.wrap(img);

                output = new ByteArrayOutputStream();
                conn = targetImage.openConnection();
                conn.setRequestProperty("User-Agent", "Firefox");

                try (InputStream inputStream = conn.getInputStream()) {
                    int n = 0;
                    byte[] buffer = new byte[1024];
                    while (-1 != (n = inputStream.read(buffer))) {
                        output.write(buffer, 0, n);
                    }

                    img = output.toByteArray();
                    targetImageBytes = ByteBuffer.wrap(img);
    
                    Image source = new Image().withBytes(sourceImageBytes);
                    Image target = new Image().withBytes(targetImageBytes);
    
                    CompareFacesRequest request = new CompareFacesRequest().withSourceImage(source).withTargetImage(target)
                            .withSimilarityThreshold(similarityThreshold);
    
                    // Call operation
                    CompareFacesResult compareFacesResult = rekognitionClient.compareFaces(request);
                    if (compareFacesResult.getFaceMatches().size()>0) {
                        map.put(workers.get(i).getId(), compareFacesResult.getFaceMatches().get(0).getSimilarity());
                    }
                }catch (Exception e) {
                    //TODO: handle exception
                }

           
            }
        }
        return ResponseEntity.ok(map);
    }

}