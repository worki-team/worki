package com.demo.model;

import com.demo.utils.ContextureType;
import com.demo.utils.EyeType;
import com.demo.utils.HairColorType;
import com.demo.utils.HairType;
import com.demo.utils.SkinType;

public class PhysicalProfile {
    
    private ContextureType contexture;
    private EyeType eyeColor;
    private HairColorType hairColor;
    private HairType hairType;
    private SkinType skinColor;
    private Float height;
    private Float weight;
    private int pantsSize;
    private String shirtSize;
    private int shoesSize;

    public PhysicalProfile(){
        
    }

    public PhysicalProfile(ContextureType contexture, EyeType eyeColor, HairColorType hairColor, HairType hairType,
            SkinType skinColor, Float height, Float weight, int pantsSize, String shirtSize, int shoesSize) {
        this.contexture = contexture;
        this.eyeColor = eyeColor;
        this.hairColor = hairColor;
        this.hairType = hairType;
        this.skinColor = skinColor;
        this.height = height;
        this.weight = weight;
        this.pantsSize = pantsSize;
        this.shirtSize = shirtSize;
        this.shoesSize = shoesSize;
    }

    public ContextureType getContexture() {
        return contexture;
    }

    public void setContexture(ContextureType contexture) {
        this.contexture = contexture;
    }

    public EyeType getEyeColor() {
        return eyeColor;
    }

    public void setEyeColor(EyeType eyeColor) {
        this.eyeColor = eyeColor;
    }

    public HairColorType getHairColor() {
        return hairColor;
    }

    public void setHairColor(HairColorType hairColor) {
        this.hairColor = hairColor;
    }

    public HairType getHairType() {
        return hairType;
    }

    public void setHairType(HairType hairType) {
        this.hairType = hairType;
    }

    public SkinType getSkinColor() {
        return skinColor;
    }

    public void setSkinColor(SkinType skinColor) {
        this.skinColor = skinColor;
    }

    public Float getHeight() {
        return height;
    }

    public void setHeight(Float height) {
        this.height = height;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public int getPantsSize() {
        return pantsSize;
    }

    public void setPantsSize(int pantsSize) {
        this.pantsSize = pantsSize;
    }

    public String getShirtSize() {
        return shirtSize;
    }

    public void setShirtSize(String shirtSize) {
        this.shirtSize = shirtSize;
    }

    public int getShoesSize() {
        return shoesSize;
    }

    public void setShoesSize(int shoesSize) {
        this.shoesSize = shoesSize;
    }

    
}