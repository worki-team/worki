package com.demo.model;

/**
 * FacesCompare
 */
public class FacesCompare {

    private String sourceImage;
    private Float similarityThreshold;

    public FacesCompare(String sourceImage, Float similarityThreshold) {
        this.sourceImage = sourceImage;
        this.similarityThreshold = similarityThreshold;
    }
    
    public String getSourceImage() {
        return sourceImage;
    }

    public void setSourceImage(String sourceImage) {
        this.sourceImage = sourceImage;
    }

    public Float getSimilarityThreshold() {
        return similarityThreshold;
    }

    public void setSimilarityThreshold(Float similarityThreshold) {
        this.similarityThreshold = similarityThreshold;
    }

}