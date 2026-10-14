<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Owner Registration</title>
</head>

<body>

    <h2>Owner Registration Form</h2>

    <form action="AddOwner" method="post">

        <!-- Personal Information -->
        <fieldset>
            <legend>Personal Information</legend>

            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" required>
            <br><br>

            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" required>
            <br><br>

            <label for="age">Age:</label>
            <input type="number" id="age" name="age" min="1" max="120" required>
            <br><br>

            <label for="gender">Gender:</label>
            <select id="gender" name="gender" required>
                <option value="">-- Select Gender --</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>
            <br><br>

            <label for="bloodGroup">Blood Group:</label>
            <select id="bloodGroup" name="bloodGroup" required>
                <option value="">-- Select Blood Group --</option>
                <option value="A+">A+</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B-">B-</option>
                <option value="AB+">AB+</option>
                <option value="AB-">AB-</option>
                <option value="O+">O+</option>
                <option value="O-">O-</option>
            </select>
            <br><br>
        </fieldset>

        <br>

        <!-- Contact Information -->
        <fieldset>
            <legend>Contact Information</legend>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <br><br>

            <label for="mobileNumber">Mobile Number:</label>
            <input type="tel" id="mobileNumber" name="mobileNumber"
                   pattern="[0-9]{10}"
                   maxlength="10"
                   required>
            <br><br>

            <label for="emergencyContact">Emergency Contact:</label>
            <input type="tel" id="emergencyContact" name="emergencyContact"
                   pattern="[0-9]{10}"
                   maxlength="10"
                   required>
            <br><br>
        </fieldset>

        <br>

        <!-- Identification & Occupation -->
        <fieldset>
            <legend>Additional Information</legend>

            <label for="aadhaarNumber">Aadhaar Number:</label>
            <input type="text" id="aadhaarNumber" name="aadhaarNumber"
                   pattern="[0-9]{12}"
                   maxlength="12"
                   required>
            <br><br>

            <label for="occupation">Occupation:</label>
            <input type="text" id="occupation" name="occupation" required>
            <br><br>
        </fieldset>

        <br>

        <!-- Flat Information -->
        <fieldset>
            <legend>Flat Information</legend>

            <label for="flatNumber">Flat Number:</label>
            <input type="text" id="flatNumber" name="flatNumber" placeholder="A101" required>
            <br><br>

            <label for="moveInDate">Move In Date:</label>
            <input type="date" id="moveInDate" name="moveInDate" required>
            <br><br>

            <label for="moveOutDate">Move Out Date:</label>
            <input type="date" id="moveOutDate" name="moveOutDate">
            <br><br>

            <label for="status">Status:</label>
            <select id="status" name="status" required>
                <option value="">-- Select Status --</option>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
                <option value="Moved Out">Moved Out</option>
            </select>
            <br><br>
        </fieldset>

        <br>

        <button type="submit">Register Owner</button>
        <button type="reset">Clear</button>

    </form>

</body>
</html>
```
